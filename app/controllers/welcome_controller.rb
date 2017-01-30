class WelcomeController < ApplicationController


  def recent_interest_questions
    @questions = pagify Question.recent_interest
    render :template => 'welcome/home'
  end

  def home
    #todo - use following query as pattern when you've decided on method for limiting home page.
    @questions = pagify Question.top_ranked
  end
  #
  # def top_answers
  #   @questions = Question.all.order()
  #   @questions = Question.order('created_at ASC').page(params[:page]).per(5)
  #   render :template => 'welcome/home'
  # end
  #
  # def top_questions
  #   @questions = Question.top_ranked_questions.page(params[:page]).per(5)
  #   render :template => 'welcome/home'
  # end
  #
  # def recent_answers
  #   @questions = Question.order('created_at DESC').page(params[:page]).per(5)
  #   render :template => 'welcome/home'
  # end

  def recent_questions
    @questions = pagify Question.recent
    render :template => 'welcome/home'
  end

  private
  def pagify(query)
    query.page(params[:page]).per(5)
  end

end