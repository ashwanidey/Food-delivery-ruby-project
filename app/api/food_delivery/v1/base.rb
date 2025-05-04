module FoodDelivery
  module V1
    class Base < Grape::API
      format :json
      version 'v1', using: :path

      get 'health' do
        { status: 'ok' }
      end

      mount FoodDelivery::V1::Auth
      mount FoodDelivery::V1::Item
      mount FoodDelivery::V1::Restaurant
      mount FoodDelivery::V1::Email
    end
  end
end