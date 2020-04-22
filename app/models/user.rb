class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :name, presence: true

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def is_recruiter
    email == Rails.application.secrets.recruiter_mail
  end
end
