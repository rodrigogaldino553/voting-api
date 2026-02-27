require "rails_helper"

RSpec.describe "Api::V1::Candidates", type: :request do
  let(:email) { "admin@example.com" }
  let(:password) { "password123" }
  let!(:user) { User.create!(email: email, password: password) }
  let!(:election) { Election.create!(name: "Test Election 2026") }

  def get_auth_headers
    post "/login", params: { user: { email: email, password: password } }, as: :json
    { "Authorization" => response.headers["Authorization"] }
  end

  let(:valid_attributes) {
    { name: "Candidate Name", election_id: election.id }
  }

  let(:invalid_attributes) {
    { name: "", election_id: nil }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Candidate.create! valid_attributes
      headers = get_auth_headers
      get api_v1_candidates_url, headers: headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      candidate = Candidate.create! valid_attributes
      headers = get_auth_headers
      get api_v1_candidate_url(candidate), headers: headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Candidate" do
        headers = get_auth_headers
        expect {
          post api_v1_candidates_url,
               params: { candidate: valid_attributes }, headers: headers, as: :json
        }.to change(Candidate, :count).by(1)
      end

      it "renders a JSON response with the new candidate" do
        headers = get_auth_headers
        post api_v1_candidates_url,
             params: { candidate: valid_attributes }, headers: headers, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Candidate" do
        headers = get_auth_headers
        expect {
          post api_v1_candidates_url,
               params: { candidate: invalid_attributes }, headers: headers, as: :json
        }.to change(Candidate, :count).by(0)
      end

      it "renders a JSON response with errors" do
        headers = get_auth_headers
        post api_v1_candidates_url,
             params: { candidate: invalid_attributes }, headers: headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) { { name: "Updated Candidate Name" } }

    it "updates the requested candidate" do
      candidate = Candidate.create! valid_attributes
      headers = get_auth_headers
      patch api_v1_candidate_url(candidate),
            params: { candidate: new_attributes }, headers: headers, as: :json
      candidate.reload
      expect(candidate.name).to eq("Updated Candidate Name")
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested candidate" do
      candidate = Candidate.create! valid_attributes
      headers = get_auth_headers
      expect {
        delete api_v1_candidate_url(candidate), headers: headers, as: :json
      }.to change(Candidate, :count).by(-1)
    end
  end
end
