require 'jwt'

class UserController < ApplicationController
  include ActionController::Cookies
  def create_user
    puts params[:email]
    existing_user = User.find_by(email: user_fields[:email])
    

    if existing_user
      render json: { message: "User already exists" }, status: :unprocessable_entity
    else
      @user = User.new(user_fields)
      begin
        @user.save!
        render json: { message: 'Successfully registered' }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      rescue => e
        render json: { message: "Something went wrong: #{e.message}" }, status: :internal_server_error
      end
    end
  end

  def sign_in
    user = User.find_by(email: params[:email])
    puts user
  
    if user && user.authenticate(params[:password])

      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      secret = Rails.application.secrets.secret_key_base
      token = JWT.encode(payload, secret)
  

      cookies.signed[:jwt] = {
        value: token,
        httponly: true,
        expires: 24.hours.from_now
      }
  
      render json: { message: "Signed in successfully" }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end 

  private

  def user_fields
    params.permit(:email, :password, :phone_number, :role, :name)
  end
end
