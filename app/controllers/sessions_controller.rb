class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = 'Invalid username or password'
      redirect_to login_path
    end
  end

  def omniauth
    @user = User.find_or_create_by(uid: omniauth_auth['uid'], provider: omniauth_auth['provider']) do |u|
      u.email = omniauth_auth.dig('info', 'email')
      u.username = omniauth_auth.dig('info', 'name') || u.email
    end

    if @user.valid?
        session[:user_id] = @user.id
        redirect_to root_path
    else
        render :new
    end
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end

  private

  attr_reader :omniauth_auth

  def omniauth_auth
    @omniauth_auth ||= request.env['omniauth.auth']
  end
end
