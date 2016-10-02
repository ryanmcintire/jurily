class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @detail = @user.user_detail
  end

  def edit
    @user = User.find(params[:id])
  end

  def new_profile
    @user = current_user
  end

  def create_profile
    puts 'testing...'
  end

end
