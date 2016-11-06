class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @detail = @user.user_detail
    @top_answers_selection = @user.top_answers(5)
    @top_questions_selection = @user.top_questions(5)
    @recent_questions_selection = @user.recent_questions(5)
    @recent_answers_selection = @user.recent_answers(5)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.user_detail.update(get_user_detail_params)
    @user.update(get_user_params)
    @user.save
    redirect_to user_url(@user)
  end

  def new_profile
    @user = current_user
  end

  def create_profile
    puts 'testing...'
  end

  private
  def get_params
    user_params = get_user_params
    user_params[:user_detail] = get_user_detail_params
    user_params
  end

  def get_user_params
    params.require(:user).permit(:email)
  end

  def get_user_detail_params
    params.require(:user_detail).permit(:first_name, :last_name, :organization, :title, :website_url, :linkedin_url)
  end

end
