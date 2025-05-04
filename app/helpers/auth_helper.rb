require 'jwt'
require 'grape-entity'


module AuthHelper
  include EmailHelper
  
  def login_user
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      
      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      secret = Rails.application.secrets.secret_key_base
      token = JWT.encode(payload, secret)
  

      cookies[:jwt] = {
        value: token,
        httponly: true,
        expires: 24.hours.from_now
      }
      # send_email(user.email, 'Welcome back to Food Delivery', 'Thank you for logging in!')
      UserLoginJob.set(wait: 10.seconds).perform_later(user.email, 'Welcome to Food Delivery', 'Thank you for registering!')
      { message: 'Logged in successfully', token: token ,user: UserEntity::Details.represent(user)}
    else
      error!('Unauthorized', 401)
    end
  end

  
  def register_user
    user = User.new(
      email: params[:email],
      password: params[:password],
      phone_number: params[:phone_number],
      role: params[:role],
      name: params[:name]
    )
  
    if user.save
      # EmailHelper::send_email(user.email, 'Welcome to Food Delivery', 'Thank you for registering!')\
      # UserLoginJob.perform_now(user.email, 'Welcome to Food Delivery', 'Thank you for registering!')
      NotifyUserJob.new.perform(user.email, 'Welcome to Food Delivery', 'Thank you for registering!')
      {message: 'User registered successfully', user: user}
    else
      error!({ message: user.errors.full_messages }, 422)
    end
  end
  


  def authenticate
    auth_header = request.headers['Authorization']
  
    if auth_header.present? && auth_header.start_with?('Bearer ')
      token = auth_header.split(' ').last
      
  
      begin
        payload, = JWT.decode(token, Rails.application.secrets.secret_key_base)
        @current_user = User.find_by(id: payload['user_id'].to_i)
       
        
  
        error!({ message: 'Unauthorized' }, 401) unless @current_user
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        error!({ message: 'Invalid token' }, 401)
      end
    else
      error!({ message: 'Unauthorized' }, 401)
    end
  end
  

  # Restricts access to admin users only
  def admin_only
    error!({ message: 'Access denied' }, 403) unless @current_user&.role == 'restaurant_admin'
  end
end
