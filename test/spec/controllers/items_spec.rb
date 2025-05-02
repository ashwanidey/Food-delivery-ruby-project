require 'rails/all'
RSpec.describe "FoodDelivery::V1::Item", type: :controller do  
  describe "GET /item" do
    context 'with valid params' do
      before :each do
        get '/item'
      end
      it 'returns a successful response' do
        byebug
        # expect {
        #   get '/api/v1/item'
        # }.to have_http_status(:ok)
      end
    end
  end
end
