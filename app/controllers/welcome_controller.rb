class WelcomeController < ApplicationController
    def index
        redirect_to "/dashboard" if current_user
    end
end
