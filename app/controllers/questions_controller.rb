require "#{Rails.root}/lib/enums/jurisdictions"

class QuestionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new


    @jurisdictions = Jurisdictions::JURISDICTIONS.keys.map do |k|
      (k.to_s).titleize
    end
    puts @jurisdictions
  end

  def create
    respond_if_not_logged_in
    @question = Question.new(user: get_user, jurisdiction: get_jurisdiction, title: params[:title], body: get_body)
    #todo - compare user.
    if @question.save
      response_data = {
          :success => true,
          :message => "Question successfully created.",
          :forwardingUrl => question_path(@question)
      }
      render status: 200, json: response_data.to_json
    end
  end

  def show
    @question = Question.find(params[:id])
    @question.views += 1 unless @question.views.nil?
    @question.views = 1 if @question.views.nil?
    @question.save
  end

  private
  def respond_if_not_logged_in
    if !current_user || current_user.id != params[:user][:id]
      response_data = {
          :success => false,
          :message => "You must be signed in to create a post."
      }
      render status: 401, json: response_data.to_json
    end
  end

  def get_user
    User.find(params[:user][:id])
    #todo - what if no user??
  end

  def get_body
    Sanitize.fragment(params[:body], Sanitize::Config::RELAXED)
  end

  def get_jurisdiction
    params[:jurisdiction].downcase
  end

end
