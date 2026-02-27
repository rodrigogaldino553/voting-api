require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }
  let(:signup_url) { "/signup" }
  let(:login_url) { "/login" }
  let(:logout_url) { "/logout" }

  describe "POST /signup" do
    context "with valid params" do
      it "returns a successful response" do
        post signup_url, params: {
          user: {
            email: "newuser@example.com",
            password: "password123"
          }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Signed up successfully.")
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post signup_url, params: {
          user: {
            email: "invalid-email",
            password: "123"
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)["message"]).to eq("Sign up failed.")
      end
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "returns a successful response and a JWT token" do
        post login_url, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.headers["Authorization"]).to be_present
        expect(JSON.parse(response.body)["message"]).to eq("Logged in successfully.")
      end
    end

    context "with invalid credentials" do
      it "returns an unauthorized response" do
        post login_url, params: {
          user: {
            email: user.email,
            password: "wrongpassword"
          }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /logout" do
    it "returns a successful response" do
      post login_url, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }, as: :json
      token = response.headers["Authorization"]

      delete logout_url, headers: { Authorization: token }, as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully.")

      get "/api/v1/elections", headers: { Authorization: token }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
