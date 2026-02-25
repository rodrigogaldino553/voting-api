class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def current_user
    @current_user ||= super || User.find(payload["sub"])
  rescue
    nil
  end

  private

  def payload
    auth_header = request.headers["Authorization"]
    token = auth_header.split(" ").last
    JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
  rescue
    nil
  end
end
