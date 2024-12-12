class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :check_root, only: [:edit, :update, :delete]

  def index
    @tasks = Task.all
  end

  def show

  end

  def new
    @task = @current_user.tasks.build
  end

  def create
    @task = @current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Задача была создана."
    else
      flash[:alert] = "Что-то пошло не так: ".concat(@task.errors.full_messages.to_sentence)
      redirect_to tasks_new_path
    end
  end

  def edit
    @task = @current_user.tasks.find(params[:id])
  end

  def update
    @task = @current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Задача была обновлена."
    else
      redirect_to edit_task_path(@task), alert: "Что-то пошло не так: ".concat(@task.errors.full_messages.to_sentence)
    end
  end

  def delete
    @task.destroy
    redirect_to tasks_path, notice: "Задача успешно удалена!"
  end

  private

  def check_root
    if @task.user_id != current_user.id
      flash[:alert] = "Недостаточно прав для действия"
      redirect_to tasks_path
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, category_ids: [])
  end
end
