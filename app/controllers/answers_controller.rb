class AnswersController < ApplicationController
  def create
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
