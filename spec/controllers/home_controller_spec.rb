require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get :index
      
      expect(JSON.parse(response.body)["message"]).to eq("Hello, World!")
    end
  end
end
