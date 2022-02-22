class QuestionsController < ApplicationController
  attr_reader :question

  before_action :load_question, only: [:edit, :update, :destroy]
  before_action :authorize_user, except: [:create]

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      create_tags
      redirect_to user_path(question.user), notice: 'Question was successfully created.'
    else
      render :edit
    end
  end

  def update
    if @question.update(question_params)
      create_tags
      redirect_to user_path(@question.user), notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    user = @question.user
    @question.destroy
    redirect_to user_path(user), notice: 'Question was successfully destroyed.'
  end

  private

  def create_tags
    question.hashtags =
      "#{question.text} #{question.answer}".
        downcase.
        scan(Hashtag::REGEXP).
        uniq.
        map { |hashtag| Hashtag.find_or_create_by(text: hashtag.delete('#')) }
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def authorize_user
    reject_user unless @question.user == current_user
  end

  def question_params
    if current_user.present? &&
      params[:question][:user_id].to_i == current_user.id
      params.require(:question).permit(:user_id, :text, :answer)
    else
      params.require(:question).permit(:user_id, :text)
    end
  end
end
