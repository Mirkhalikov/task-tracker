class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password_hash])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: "Вы успешно вошли в систему."
    else
      flash.now[:alert] = "Неверное имя пользователя или пароль."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Вы вышли из системы."
  end
end
