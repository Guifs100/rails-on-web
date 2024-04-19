require 'bcrypt'

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
    @user = User.find_or_create_by(uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider']) do |u|
        u.username = request.env['omniauth.auth']['info']['name']
        u.email = request.env['omniauth.auth']['info']['email']
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
end
