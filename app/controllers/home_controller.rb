class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]
  def index
    render plain: "Hello, World!"
  end
end
