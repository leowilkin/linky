class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new]

  def new
    # Login page - will have button_to for POST to /auth/authentik
  end

  def create
    # OmniAuth provides auth data in request.env['omniauth.auth']
    auth = request.env['omniauth.auth']
    
    if auth.nil?
      redirect_to root_path, alert: 'Authentication failed'
      return
    end
    
    # Create/find user using OmniAuth data
    user = User.where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      u.email = auth.info.email
      u.name = auth.info.name
    end
    
    # Prevent session fixation
    reset_session
    session[:user_id] = user.id
    
    # Redirect to original destination or root
    redirect_to root_path, notice: 'Successfully logged in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully'
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed'
  end
end
