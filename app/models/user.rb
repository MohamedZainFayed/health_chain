class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV["TWO_FACTOR_ENCRYPTION_KEY"]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :activate_otp
  
  def activate_otp
    # self.otp_required_for_login = true
    self.unconfirmed_otp_secret = User.generate_otp_secret
    self.otp_secret = unconfirmed_otp_secret
    self.tfa_cipher = unconfirmed_otp_secret
    self.unconfirmed_otp_secret = nil
    save!
  end

  def deactivate_otp
    self.otp_required_for_login = false
    self.otp_secret = tfa_cipher
    save!
  end
end
