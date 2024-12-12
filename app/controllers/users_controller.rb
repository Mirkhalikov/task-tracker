class UsersController < ApplicationController
  before_action :check_root, only: [ :edit, :update ]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: "Регистрация прошла успешно."
    else
      redirect_to signup_path, notice: "Что-то пошло не так!".concat(@user.errors.full_messages.to_sentence)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "Профиль обновлён."
    else
      redirect_to edit_user_path(@user), alert: "Что-то пошло не так: ".concat(@user.errors.full_messages.to_sentence)
    end
  end

  private

  def check_root
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:alert] = "Недостаточно прав для действия"
      redirect_to users_path
    end
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end
end
