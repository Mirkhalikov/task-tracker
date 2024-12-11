class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @categories = Category.all
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      redirect_to tasks_path, notice: 'Задача создана.'
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @categories = Category.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'Задача обновлена.'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: 'Задача удалена.'
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, category_ids: [])
  end
end
