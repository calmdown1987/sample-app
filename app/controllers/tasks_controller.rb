class TasksController < ApplicationController
before_action:set_user
before_action:set_task, only: %i(show edit update destroy)

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
  
  def set_task
    @task = @user.tasks.find_by(id: params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
  
  def params_task
    params.require(:task).permit(:name,:description)
  end
end