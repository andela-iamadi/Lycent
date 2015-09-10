class ApplicationController < ActionController::Base
  add_breadcrumb :root # 'root_path' will be used as url
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_referrer
  include SessionsHelper

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    if !current_user
      flash[:danger] = "Ummm.. you may need to log in at this point"
      redirect_to login_path
    end
  end

  def store_referrer
    referer = request.referer.presence
    if referer && !referer.start_with?(Rails.application.secrets.app_url)
      session[:referrer] ||= referer
    end
  end
end
