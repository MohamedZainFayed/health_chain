class DashboardController < ApplicationController

    require 'net/http'
    require 'uri'
    require 'json'

    def index
        @users = User.all
        @patient = Patient.new
        puts params
        if params[:id] && !Patient.where(id: params[:id]).empty?
            uri = URI("http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/patient/#{params[:id]}")
            @result = JSON.parse(Net::HTTP.get(uri))
        end
    end
    
    def show_patient
        redirect_to "/", notice: "invalid patient national id" if params[:id].nil? || Patient.where(id: params[:id]).empty?
        uri = URI("http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/patient/#{params[:id]}")
        @record = Record.new
        @patient = JSON.parse(Net::HTTP.get(uri)) rescue nil
        uri = URI("http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/record")
        @records = JSON.parse(Net::HTTP.get(uri)) rescue []
        @records = @records.select{|r| r if r["owner"] == "resource:org.acme.medicalchain.patient##{params[:id]}"}
        for i in 0..@records.length
            @records[i]["doctor"] = User.where(national_id: @records[i]["writer"]["resource:org.acme.medicalchain.doctor#".length .. @records[i]["writer"].length]).first.name if @records[i]
        end
    end

    def get_info
        redirect_to "/dashboard?id=#{params[:patient]["id"]}"
    end

    def add_record
        @record = Record.new params.require(:record).permit(:national_id, :diagnosist)
        if @record.save
            p = { "recordID": @record.id,
                "diagnosist": @record.diagnosist,
                "owner": "resource:org.acme.medicalchain.patient##{@record.national_id}",
                "writer": "resource:org.acme.medicalchain.doctor##{current_user.national_id}"
            }
            chain_url = "http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/record"
            RestClient.post(chain_url, p.to_json, {content_type: :json, accept: :json})
            redirect_to "/show_patient/#{@record.national_id}", notice: "Record saved!"
        else
            redirect_to "/show_patient/#{@record.national_id}", notice: "Record not saved!"
        end
    end

    def new_doctor
        redirect_to "/", notice: "Access not granted!" unless current_user && current_user.admin?
        @doctor = User.new
    end

    def delete_doctor
        user = User.find_by_id params[:id]
        chain_url = "http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/doctor/#{user.national_id}"
        RestClient.delete(chain_url) rescue nil
        user.delete
        redirect_to "/", notice: "Doctor removed!"
    end

    def create_doctor
        p = {
            "doctorID": params[:user][:national_id],
            "fName": params[:user][:fname],
            "lname": params[:user][:lname],
            "GenderType": "male",
            "Age": params[:user][:age],
            "email": params[:user][:email],
            "PhonNumber": params[:user][:phone_number],
            "address": {
              "city": params[:user][:city],
              "street": params[:user][:street]
            },
            "department": params[:user][:department]
          }
        chain_url = "http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/doctor"
        doctor = User.new({email: params[:user][:email], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], national_id: params[:user][:national_id]})
        if doctor.save
            RestClient.post(chain_url, p.to_json, {content_type: :json, accept: :json})
            redirect_to "/dashboard", notice: "Doctor added!"
        else
            redirect_to "/new_doctor", alert: "Doctor not added!"
        end
    end

    def new_patient
        @patient = Patient.new
    end

    def create_patient
        p = {
            "patientID": params[:patient][:id],
            "fName": params[:patient][:fname],
            "lname": params[:patient][:lname],
            "GenderType": params[:patient][:gender],
            "Age": params[:patient][:age],
            "email": "null",
            "PhonNumber": params[:patient][:phone_number],
            "address": {
              "city": params[:patient][:city],
              "street": params[:patient][:street]
            },
            "department": "null"
          }
        chain_url = "http://ec2-18-216-204-179.us-east-2.compute.amazonaws.com:3000/api/patient"
        patient = Patient.new params.require(:patient).permit(:id, :fname, :lname, :age, :gender, :phone_number, :city, :street)
        if Patient.where(id: params[:patient][:id]).empty? && patient.save
            RestClient.post(chain_url, p.to_json, {content_type: :json, accept: :json})
            redirect_to "/dashboard", notice: "Patient added!"
        else
            redirect_to "/new_patient", alert: "Patient not added!"
        end
    end
end
