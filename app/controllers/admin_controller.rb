class AdminController < ApplicationController

  def dashboard

  end

  def user_list
    @users = pagify User.all
  end

  def question_list
    @questions = pagify Question.all
  end

  private
  def pagify(query)
    query.page(params[:page]).per(30)
  end

end
