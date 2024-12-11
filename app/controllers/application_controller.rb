class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_user

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    unless @current_user
      redirect_to login_path, alert: "Пожалуйста, войдите в систему."
    end
  end
end
