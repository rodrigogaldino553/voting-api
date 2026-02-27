class Users::SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "Logged in successfully.",
        user: resource
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy(_opts = {})
    if current_user
      render json: {
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
