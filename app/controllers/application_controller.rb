class ApplicationController < ActionController::Base
  private

  def required_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def logged_in?
    current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # JWT_SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  #TODO colocar expiração por tempo
  def encode
    JWT.encode({}, ENV['JWT_SECRET_KEY'], 'HS256')
  end
end
