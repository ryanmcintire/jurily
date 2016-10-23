class WelcomeController < ApplicationController
  def home

    #todo - use following query as pattern when you've decided on method for limiting home page.
    #@questions = Question.jurisdiction(nil).order('created_at DESC').page(params[:page]).per(5)

    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
  end
end