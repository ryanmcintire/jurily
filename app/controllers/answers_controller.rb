class AnswersController < ApplicationController

  before_action :authenticate_user!, only: :delete

  def create
    respond_if_not_logged_in
    question = Question.find(params[:questionId])
    answer = Answer.new(user: get_user, body: get_body)
    question.answers << answer
    if question.save
      response_data = {
          :success => true,
          :message => "Answer successfully created.",
          :forwardingUrl => question_path(question)
      }
      render status: 200, json: response_data.to_json
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    answer.delete
    if answer.save
      redirect_to question_url(answer.question)
    else
      #todo - flash error msg
      redirect_to question_url(answer.question)
    end
  end

  def edit

  end

  private
  def respond_if_not_logged_in
    if !current_user || current_user.id != params[:user][:id]
      response_data = {
          :success => false,
          :message => "You must be signed in to answer a question."
      }
      render status: 401, json: response_data.to_json
    end
  end

  def get_user
    User.find(params[:user][:id])
  end

  def get_body
    Sanitize.fragment(params[:body], Sanitize::Config::RELAXED)
  end

end
