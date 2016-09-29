class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @detail = @user.user_detail
  end

end
