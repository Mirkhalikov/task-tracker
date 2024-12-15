class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :check_root, only: [ :edit, :update, :delete ]

  def index
    @users = User.all
    @tasks = Task.all

    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end

    if params[:assigned_user_id].present?
      @tasks = @tasks.where(assigned_user_id: params[:assigned_user_id])
    end

    if params[:category_id].present?
      @tasks = @tasks.joins(:categories).where(categories: { id: params[:category_id] })
    end

    @tasks = @tasks.page(params[:page]).per(6)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = @current_user.tasks.build
    @users = User.all
  end

  def delete
    @task.destroy
    redirect_to tasks_path, notice: "Задача успешно удалена!"
  end

  def create
    @task = @current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Задача была создана."
    else
      flash[:alert] = "Что-то пошло не так: ".concat(@task.errors.full_messages.to_sentence)
      redirect_to new_task_path
    end
  end

  def edit
    @task = @current_user.tasks.find(params[:id])
    @users = User.all
  end

  def update
    @task = @current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Задача была обновлена."
    else
      redirect_to edit_task_path(@task), alert: "Что-то пошло не так: ".concat(@task.errors.full_messages.to_sentence)
    end
  end

  private

  def check_root
    @task = Task.find(params[:id])
    if @task.user_id != current_user.id
      flash[:alert] = "Недостаточно прав для действия"
      redirect_to tasks_path
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :assigned_user_id, category_ids: [])
  end
end
