class WelcomeController < ApplicationController
  def home
    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
  end
end