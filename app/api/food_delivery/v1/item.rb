module FoodDelivery
  module V1
    class Item < Grape::API
      version 'v1', using: :path
      format :json
      helpers AuthHelper
      helpers ItemHelper


      before do
        authenticate unless route.settings[:skip_auth]
      end

      before do
        admin_only unless route.settings[:skip_admin]
      end

      resources '/admin' do
        desc "Create a Food Item"
        params do
          requires :name, type: String, desc: 'Food name'
          requires :price, type: Integer, desc: 'Food price'
          requires :category, type: String, desc: 'Food category'
          requires :restaurant_id, type: Integer, desc: 'Restaurant ID'
        end
        post '/item' do
          create_item
        end

        desc "Search Item"
        params do
          requires :query, type: String, desc: 'query to search'
        end
  
        get '/search/item', route_setting: { skip_auth: true, skip_admin: true } do
          search_items
        end
      end
    end
  end
end
