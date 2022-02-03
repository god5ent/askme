class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user.present?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Successfully logged in!'
    else
      flash.now.alert = 'Неуспех :/ Пароль либо почта не подходит'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Покеда!'
  end
end
