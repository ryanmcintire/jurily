
require "#{Rails.root}/lib/enums/jurisdictions"

class QuestionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @jurisdictions = Jurisdictions::JURISDICTIONS.keys.map do |k|
      (k.to_s).titleize
    end
  end

  def edit
    @question = Question.find(params[:id])
    @jurisdictions = Jurisdictions::JURISDICTIONS.keys.map do |k|
      (k.to_s).titleize
    end
    @current_jurisdiction = @question.jurisdiction.to_s.titleize
  end

  def create
    respond_if_not_logged_in
    begin
      @question = Question.new(
          user: get_user,
          jurisdiction: get_jurisdiction,
          title: params[:title],
          body: get_body)
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
    respond_if_not_logged_in
    begin
      @question = Question.find(params[:id])
    rescue ArgumentError => e
      send_error_response "Invalid data." and return
    end
    @question.assign_attributes(
                 jurisdiction: get_jurisdiction,
                 title: params[:title],
                 body: get_body)
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
    params[:jurisdiction].downcase.to_s
        .parameterize
        .underscore
        .to_sym
  end

  def send_error_response(msg)
    response_data = {
        success: false,
        message: msg
    }
    render status: 400, json: response_data.to_json
  end

end
