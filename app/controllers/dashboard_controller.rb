class DashboardController < ApplicationController

    require 'net/http'
    require 'uri'
    require 'json'

    def index 
    end

    def new_doctor
        redirect_to "/", notice: "Access not granted!" unless current_user && current_user.admin?
        @doctor = User.new
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
        doctor = User.new({email: params[:user][:email], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation]})
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
        if Patient.where(id: params[:patient][:id]).empty && patient.save
            puts p
            RestClient.post(chain_url, p.to_json, {content_type: :json, accept: :json})
            redirect_to "/dashboard", notice: "Patient added!"
        else
            redirect_to "/new_patient", alert: "Patient not added!"
        end
    end
end
