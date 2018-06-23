class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => "c4c17a97f2d65f3ca6d731d45b27cdc1d27ee392c873efba2dca3186514263c79e83d8a891cebe84febc6f1824730d861baaf10e99e85834b541aedcc897edd1"

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

  def admin?
    !Admin.where(user_id: self.id).empty?
  end
end
