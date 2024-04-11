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
    # user_info = request.env['omniauth.auth']
    # session['auth_data'] = user_info
    # p '====================================================================='
    # p session['auth_data']
    # p '====================================================================='
    # redirect_to '/home'
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end
end
