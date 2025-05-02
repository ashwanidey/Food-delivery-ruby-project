module FoodDelivery
  module V1
    class Restaurant < Grape::API
      version 'v1', using: :path
      format :json
      
      helpers RestaurantHelper

      resources '/admin' do
        desc "Create a restaurant"
       params do
        requires :name, type: String, desc: 'Food name'
       end
       post '/restaurant' do
        create_new_restaurant 
       end


       desc 'List Menu Items' 
      params do
        requires :id, type: String, desc: 'Restaurant ID'
      end
      get '/foods/restaurant' do
        get_restaurant_foods
      end

        
      end
    end
  end
end
