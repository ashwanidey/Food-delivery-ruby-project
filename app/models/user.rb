class User < ApplicationRecord
  has_secure_password

  VALID_ROLES = %w[restaurant_admin foodie delivery_agent]

  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :phone_number, presence: true, numericality: { only_integer: true }, length: { minimum: 10 }
  validates :role, presence: true, inclusion: { in: VALID_ROLES }
  validates :name, presence: true
end
