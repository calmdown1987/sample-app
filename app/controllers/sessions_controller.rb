class SessionsController < ApplicationController
  #before_action :logged_in_login, only:[:new]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
  def logged_in_login
    if logged_in?
      flash[:danger] = "すでにログインしています"
      redirect_to current_user
    end
  end
end
