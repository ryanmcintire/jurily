require "#{Rails.root}/lib/enums/jurisdictions"
require 'pp'

class QuestionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @questions = Question.where(nil) # creates anonymous scope.
    @questions = @questions.by_jurisdiction(*filter(:jurisdiction)) if filter(:jurisdiction).present?
    @questions = @questions.by_tag_name(*filter(:tag)) if filter([:tag]).present?
    @questions = @questions.sort_by_score
    @questions = @questions.page(params[:page]).per(10)
  end

  def new
    @question = Question.new
    @jurisdictions = Jurisdictions::JURISDICTIONS.keys.map do |k|
      (k.to_s).titleize
    end
  end

  def edit
    @jurisdictions = Jurisdictions::JURISDICTIONS.keys.map { |k| (k.to_s).titleize }
    q = Question.find(params[:id])
    @question = {
        id: q.id,
        tags: q.tags.map { |t| t.name },
        title: q.title,
        jurisdiction: q.jurisdiction.to_s.titleize,
        body: q.body
    }
  end

  def create
    respond_if_not_logged_in

    begin
      @question = Question.new(
          user: current_user,
          jurisdiction: jurisdiction,
          title: params[:question][:title],
          tags: tags,
          body: body)
    rescue ArgumentError => e
      send_error_response "Invalid data." and return
    end

    #todo - compare user.

    if @question.save
      response_data = {
          :success => true,
          :message => "Question successfully created.",
          :forwardingUrl => question_path(@question)
      }
      render status: 200, json: response_data.to_json
    else
      #todo - actually parse out the error message.
      send_error_response "Invalid data." and return
    end
  end

  def update
    begin
      @question = Question.find(params[:id])
    rescue ArgumentError => e
      send_error_response "Invalid data." and return
    end
    respond_if_not_logged_in(@question.user.id)

    @question.assign_attributes(
        jurisdiction: jurisdiction,
        title: params[:title],
        body: body,
        tags: tags
    )
    if @question.save
      response_data = {
          :success => true,
          :message => "Question successfully updated.",
          :forwardingUrl => question_path(@question)
      }
      render status: 200, json: response_data.to_json
    else
      send_error_response "Invalid data." and return
    end
  end

  def show
    @question = Question.find(params[:id])
    @question.views += 1 unless @question.views.nil?
    @question.views = 1 if @question.views.nil?
    @answers = @question.answers.sort { |x, y| y.score <=> x.score }
    #todo - I need to have error protection here...
    @question.save
  end

  private
  def respond_if_not_logged_in(question_user_id=nil)
    if !current_user or (question_user_id and question_user_id != current_user.id)
      response_data = {
          :success => false,
          :message => "You must be signed in to create a post."
      }
      render status: 401, json: response_data.to_json
    end
  end

  def user_id
    User.find(params[:user][:id])
    #todo - what if no user??
  end

  def body
    Sanitize.fragment(params[:question][:body], Sanitize::Config::RELAXED)
  end

  def jurisdiction
    params[:question][:jurisdiction].downcase.to_s
        .parameterize
        .underscore
        .to_sym
  end

  def tags
    if params[:question][:tags]
      params[:question][:tags].map { |t| Tag.find_or_create_by(name: t) }
    else
      []
    end
  end

  def send_error_response(msg)
    response_data = {
        success: false,
        message: msg
    }
    render status: 400, json: response_data.to_json
  end

  def filter(key)
    params[:filter][key]
  end

end