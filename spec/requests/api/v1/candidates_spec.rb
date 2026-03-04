require "rails_helper"

RSpec.describe "Api::V1::Candidates", type: :request do
  let(:email) { "admin@example.com" }
  let(:password) { "password123" }
  let!(:user) { create(:user) }
  let!(:election) { create(:election, name: "Test Election 2026", user: user) }
  let(:valid_headers) {
    post "/login", params: {user: {email: user.email, password: user.password}}, as: :json
    {"Authorization" => response.headers["Authorization"]}
  }

  let(:valid_attributes) {
    {name: "Candidate Name", election_id: election.id}
  }

  let(:invalid_attributes) {
    {name: "", election_id: election.id}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Candidate.create! valid_attributes
      get api_v1_election_candidates_url(election.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      candidate = Candidate.create! valid_attributes
      get api_v1_candidate_url(candidate), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Candidate" do
        expect {
          post api_v1_election_candidates_url(election.id),
            params: {candidate: valid_attributes}, headers: valid_headers, as: :json
        }.to change(Candidate, :count).by(1)
      end

      it "renders a JSON response with the new candidate" do
        post api_v1_election_candidates_url(election.id),
          params: {candidate: valid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Candidate" do
        expect {
          post api_v1_election_candidates_url(election.id),
            params: {candidate: invalid_attributes}, headers: valid_headers, as: :json
        }.to change(Candidate, :count).by(0)
      end

      it "when current_user is not the election owner" do
        post api_v1_election_candidates_url(election.id),
          params: {candidate: {election_id: 0}, headers: valid_headers, as: :json}
        expect(response).to have_http_status(:unauthorized)
      end

      it "renders a JSON response with errors" do
        post api_v1_election_candidates_url(election.id),
          params: {candidate: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) { {name: "Updated Candidate Name"} }

    it "updates the requested candidate" do
      candidate = Candidate.create! valid_attributes
      patch api_v1_candidate_url(candidate),
        params: {candidate: new_attributes}, headers: valid_headers, as: :json
      candidate.reload
      expect(candidate.name).to eq("Updated Candidate Name")
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested candidate" do
      candidate = Candidate.create! valid_attributes
      expect {
        delete api_v1_candidate_url(candidate), headers: valid_headers, as: :json
      }.to change(Candidate, :count).by(-1)
    end
  end
end
