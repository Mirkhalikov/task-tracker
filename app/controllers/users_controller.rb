class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    authenticate_user! # Проверка на авторизацию
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: 'Регистрация прошла успешно.'
    else
      render :new
    end
  end

  def edit
    authenticate_user! # Проверка на авторизацию
    @user = User.find(params[:id])
  end

  def update
    authenticate_user! # Проверка на авторизацию
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "Профиль обновлён."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end
end
