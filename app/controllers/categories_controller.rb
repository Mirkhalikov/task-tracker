class CategoriesController < ApplicationController
  before_action :authenticate_user

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Категория была создана."
    else
      flash[:alert] = "Что-то пошло не так: #{@category.errors.full_messages.to_sentence}"
      redirect_to new_category_path
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: "Категория была обновлена."
    else
      flash[:alert] = "Что-то пошло не так: #{@category.errors.full_messages.to_sentence}"
      redirect_to edit_category_path(@category)
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "Категория была удалена."
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
