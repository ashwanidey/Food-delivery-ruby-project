module FoodDelivery
  module V1
    class Auth < Grape::API
      version 'v1', using: :path
      format :json
      helpers AuthHelper

      resources '/auth' do
        desc 'Authenticate and get a token'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
        post '/login' do
          login_user
        end

        desc 'Register a new user'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
        requires :phone_number, type: String, desc: 'Phone Number of the User'
        requires :role, type: String, desc: 'Role'
        requires :name, type: String, desc: 'Name of the User'
      end
        post '/register' do
          register_user
        end
      end
    end
  end
end
