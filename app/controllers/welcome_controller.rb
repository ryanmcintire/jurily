class WelcomeController < ApplicationController
  def home
    #todo - use following query as pattern when you've decided on method for limiting home page.
    #@questions = Question.jurisdiction(nil).order('created_at DESC').page(params[:page]).per(5)
    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
  end

  def top_answers

    @questions = Question.all.order()
    @questions = Question.order('created_at ASC').page(params[:page]).per(5)
    render :template => 'welcome/home'
  end

  def top_questions
    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
    render :template => 'welcome/home'
  end

  def recent_answers
    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
    render :template => 'welcome/home'
  end

  def recent_questions
    @questions = Question.order('created_at DESC').page(params[:page]).per(5)
    render :template => 'welcome/home'
  end

end