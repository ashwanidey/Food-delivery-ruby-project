require 'rails_helper'
require 'jwt'

RSpec.describe "FoodDelivery::V1::Item", type: :request do
  let(:user) { create(:user) }
let(:restaurant) { create(:restaurant, user: user) }
let!(:item) { create(:item, name: "Paneer2", restaurant: restaurant) }


  describe "GET /api/v1/admin/item" do
    context 'with valid params and authorization' do
      it 'returns a list of items' do
        get '/api/v1/admin/item', headers: { 'Authorization' => auth_token }
  
        expect(response).to have_http_status(:ok)
       
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_an(Array)
        expect(parsed_response.first["name"]).to eq("Paneer2")
      end
    end

    context 'without authorization' do
      it 'returns an unauthorized error' do
        get '/api/v1/admin/item'

        expect(response).to have_http_status(:unauthorized)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq("Unauthorized")
      end
    end
  end

  describe "POST /api/v1/admin/item" do
    let(:valid_params) do
      {
        name: "Paneer Tikka",
        price: 150,
        category: "Veg",
        restaurant_id: restaurant.id
      }
    end

    context 'with valid params and authorization' do
      it 'creates a new item' do
        post '/api/v1/admin/item', params: valid_params, headers: { 'Authorization' => auth_token }

        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq("Food item created successfully")
        expect(parsed_response["food"]["name"]).to eq("Paneer Tikka")
      end
    end

    context 'with invalid params' do
      it 'returns a validation error' do
        invalid_params = valid_params.merge(price: -10)
        post '/api/v1/admin/item', params: invalid_params, headers: { 'Authorization' => auth_token }

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to include("Validation failed")
        expect(parsed_response["errors"]).to include("Price must be greater than or equal to 0")
      end
    end
  end

  describe "GET /api/v1/admin/search/item" do
    context 'with a valid query' do
      it 'returns search results' do
        get '/api/v1/admin/search/item', params: { query: "Paneer" }, headers: { 'Authorization' => auth_token }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq("Search results")
        expect(parsed_response["results"].first["name"]).to eq("Paneer2")
      end
    end

    context 'with an empty query' do
      it 'returns a validation error' do
        get '/api/v1/admin/search/item', params: { query: "" }, headers: { 'Authorization' => auth_token }

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq("Search query cannot be blank")
      end
    end

    context 'with no matching results' do
      it 'returns a not found error' do
        get '/api/v1/admin/search/item', params: { query: "NonExistentItem" }, headers: { 'Authorization' => auth_token }

        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq("No results found")
      end
    end
  end
end
