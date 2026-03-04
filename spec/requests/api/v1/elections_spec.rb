require "rails_helper"
RSpec.describe "/api/v1/elections", type: :request do
  let(:user) { User.create!(email: "admin@example.com", password: "password123") }
  let(:valid_headers) {
    post "/login", params: {user: {email: user.email, password: user.password}}, as: :json
    {"Authorization" => response.headers["Authorization"]}
  }

  let(:valid_attributes) {
    {name: "General Election 2026", user_id: user.id}
  }

  let(:invalid_attributes) {
    {name: ""}
  }

  describe "GET /index" do
    it "renders a successful response for authenticated in users" do
      Election.create! valid_attributes
      get api_v1_elections_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it "renders a successful response for unauthenticated users" do
      Election.create! valid_attributes
      get api_v1_elections_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      election = Election.create! valid_attributes
      get api_v1_election_url(election), headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it "renders a successful response for unauthenticated users" do
      election = Election.create! valid_attributes
      get api_v1_election_url(election), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Election" do
        expect {
          post api_v1_elections_url,
            params: {election: valid_attributes}, headers: valid_headers, as: :json
        }.to change(Election, :count).by(1)
      end

      it "renders a JSON response with the new election" do
        post api_v1_elections_url,
          params: {election: valid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "unallowed for unauthenticated users" do
        post api_v1_elections_url,
          params: {election: valid_attributes}, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Election" do
        expect {
          post api_v1_elections_url,
            params: {election: invalid_attributes}, headers: valid_headers, as: :json
        }.to change(Election, :count).by(0)
      end

      it "renders a JSON response with errors for the new election" do
        post api_v1_elections_url,
          params: {election: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {name: "Updated Election Name"}
      }

      it "updates the requested election" do
        election = Election.create! valid_attributes
        patch api_v1_election_url(election),
          params: {election: new_attributes}, headers: valid_headers, as: :json
        election.reload
        expect(election.name).to eq("Updated Election Name")
      end

      it "renders a JSON response with the election" do
        election = Election.create! valid_attributes
        patch api_v1_election_url(election),
          params: {election: new_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the election" do
        election = Election.create! valid_attributes
        patch api_v1_election_url(election),
          params: {election: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested election" do
      election = Election.create! valid_attributes
      expect {
        delete api_v1_election_url(election), headers: valid_headers, as: :json
      }.to change(Election, :count).by(-1)
    end
  end
end
