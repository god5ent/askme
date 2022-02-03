class UsersController < ApplicationController

  before_action :load_user, except: [:index, :create, :new]
  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.all
  end

  def new
    redirect_to root_url, alert: 'Dont, buddy' if current_user.present?
    @user = User.new

  end

  def create
    redirect_to root_url, alert: 'Dont, buddy' if current_user.present?
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Велкам'
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Settings updated!'
    else
      render 'edit'
    end
  end

  def edit
  end

  def show
    @questions = @user.questions.order(created_at: :desc)

    @new_question = @user.questions.build

    # Создаем три переменные с количеством вопросов, отвеченных вопросов и
    # безответных вопросов
    @questions_count = @questions.count
    @answers_count = @questions.count(&:answer)
    @unanswered_count = @questions_count - @answers_count
  end

end

private

def authorize_user
  reject_user unless @user == current_user
end

def load_user
  @user ||= User.find params[:id]
end

def user_params
  params.require(:user)
        .permit(:email, :password, :password_confirmation, :name, :username, :avatar_url, :background_color)
end

