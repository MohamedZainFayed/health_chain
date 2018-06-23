class DashboardController < ApplicationController

    require 'net/http'
    require 'uri'
    require 'json'

    def index 
    end

    def new_doctor
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
        host_url = "http://health-chain.herokuapp.com/users"
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
end
