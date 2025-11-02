class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  helper_method :human_time, :current_user, :logged_in?

  def human_time(time)
    time.strftime("%m/%d/%Y %I:%M %p")
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      session[:return_to] = request.fullpath
      redirect_to login_path, alert: 'Please log in to continue'
    end
  end

  def require_admin
    admin_emails = ENV.fetch('ADMIN_EMAILS', '').split(',').map(&:strip)
    unless current_user && admin_emails.include?(current_user.email)
      head :forbidden
    end
  end

end
