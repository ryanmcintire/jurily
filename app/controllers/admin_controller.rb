class AdminController < ApplicationController
  before_action :is_admin?

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

  def is_admin?
    if !current_user.try(:admin?)
      redirect_to new_user_session_url
    end
  end

end
