class UsersController < ApplicationController
  before_action :logged_in_user, only:[:show, :edit, :update]
  before_action :admin_user, only:[:index,:destroy]
  before_action :correct_user, only:[:show]

  def show
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    redirect_to @user
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
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
        flash[:danger] ="管理者のみアクセスもしくは実行できます"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
        unless @user == current_user
          flash[:danger] = "登録者本人のみがアクセスできます"
          redirect_to login_url
        end
    end
end
