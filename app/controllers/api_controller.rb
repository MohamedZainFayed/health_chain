class ApiController < ApplicationController
    skip_before_action :authenticate_user!

    def user_auth
        @user = User.where(email: params[:email]).first
        render json: {error: "User doesn't exist"} and return if @user.nil?
        render json: {error: "Password doesn't match"} and return unless @user.valid_password?(params[:password])
        render json: @user.as_json
    end

    def user_exist
        @user = User.where(email: params[:email]).first
        render json: {notice: "User doesn't exist"} and return if @user.nil?
        render json: {notice: "User exists"}
    end

end
