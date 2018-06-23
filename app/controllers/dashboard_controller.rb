class DashboardController < ApplicationController

    def index 
    end

    def new_doctor
        @doctor = User.new
    end

    def new_patient
        @patient = Patient.new
    end
end
