class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :resume_session

  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    Current.user
  end

  private

  def pundit_user
    current_user
  end

  def user_not_authorized
    redirect_to root_path,
                alert: "You are not authorized to perform this action."
  end
end
