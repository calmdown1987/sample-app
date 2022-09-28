class TasksController < ApplicationController
before_action:set_user
before_action:set_task, only: %i(show edit update destroy)
before_action:task_logged_in_user, only:[:index,:new,:show,:edit]
before_action:correct_user, only:[:index,:new,:show,:edit]


  def index
    @tasks = @user.tasks
  end
  
  def new
    @task = Task.new    
  end
  
  def create
    @task = @user.tasks.build(params_task)
    if @task.save
       redirect_to user_tasks_url
    else
       render :new
    end
  end
  
  def update
    if @task.update_attributes(params_task)
       redirect_to user_tasks_url
    else
      render :edit
    end
  end
  
  def show
  end

  def edit
  end
  
  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました。"
    redirect_to user_tasks_url
  end
  
  def set_task
    @task = @user.tasks.find_by(id: params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
  
  def params_task
    params.require(:task).permit(:name,:description)
  end
  
  def task_logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
  
  def correct_user
    unless @user == current_user
      flash[:danger] ="ログインしてください"
      redirect_to login_url
    end
  end

end