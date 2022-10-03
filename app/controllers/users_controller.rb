class UsersController < ApplicationController
  before_action :set_user, only:[:show, :update, :edit, :destroy, :correct_user, :admin_or_correct_user]
  before_action :logged_in_user, only:[:index,:show,:update]
  before_action :admin_user, only:[:index]
  before_action :correct_user, only:[:edit]
  before_action :admin_or_correct_user, only:[:show]
  before_action :logged_in_signup, only:[:new]

  def show
  end
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def update
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render :edit
    end
  end
  
  def edit
  end
  
  def destroy
    @user.destroy
    flash[:danger] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    private
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    def admin_user
      unless current_user.admin?
        flash[:danger] ="管理者のみアクセスできます"
        redirect_to(root_url)
      end
    end
    
    def correct_user
        unless @user == current_user
          flash[:danger] = "登録者本人のみがアクセスできます"
          redirect_to login_url
        end
    end

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
    
    def logged_in_signup
      if logged_in? && !current_user.admin?
         flash[:danger] = "すでにログインしています。"
         redirect_to user_url(current_user)
      end
    end
end
