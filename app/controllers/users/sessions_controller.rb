# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create
    return redirect_to new_user_session_path unless user_exist?
    user = User.find_by(id: session[:temp_user_id])
    return render :otp  if user.otp_required_for_login
    create_session(user)
  end
  
  def user_exist?
    return false unless user = User.find_by(email: params[:user][:email])
    return false unless user.valid_password?(params[:user][:password])
    session[:temp_user_id] = user.id
    true
  end

  def verify_otp
    if current_user && !current_user.otp_required_for_login
      if current_user.validate_and_consume_otp!(params[:otp_attempt], otp_secret: current_user.otp_secret)
        current_user.otp_required_for_login = true
        current_user.save!
        redirect_to edit_user_registration_path, notice: "Two-Factor activated!"
      else
        redirect_to "/two_factor/activate", alert: "Invalid OTP!"
      end
    else
      user = User.find_by(id: session[:temp_user_id])
      if user.validate_and_consume_otp!(params[:otp_attempt], otp_secret: user.otp_secret)
        create_session(user)
      else
        render :otp
      end
    end
  end

  def create_session(user)
    sign_in(user)
    session.delete(:temp_user_id)
    redirect_to "/dashboard", notice: "Signed in successfully!"
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
