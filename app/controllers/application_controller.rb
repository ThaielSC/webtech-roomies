class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) || User.first
  end

  def switch_user
    session[:current_user_id] = User.find(params[:user_id]).id
    redirect_back fallback_location: root_path, notice: "Acting user changed."
  end
end
