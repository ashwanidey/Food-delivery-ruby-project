require 'grape'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'user/sign-in', to: 'user#sign_in'
  post 'user/create-user', to: 'user#create_user'
  mount FoodDelivery::Base => "/"
  
end
