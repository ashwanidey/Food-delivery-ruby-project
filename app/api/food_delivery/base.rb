
  module FoodDelivery
    class Base < Grape::API
      prefix 'api'
      format :json
      version 'v1', using: :path

      mount FoodDelivery::V1::Base

    end
  end