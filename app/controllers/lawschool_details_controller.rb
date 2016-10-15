class LawschoolDetailsController < ApplicationController
  before_action :authenticate_user!

  def new
    @lawschool_detail = LawschoolDetail.new
  end

  def create
    current_user.user_detail.lawschool_detail = LawschoolDetail.new(lawschool_detail_params)
    if current_user.user_detail.save
      redirect_to user_url(current_user)
    else
      render :new
    end
  end

  def destroy
    lawschool_detail = LawschoolDetail.find(params[:id])
    lawschool_detail.destroy
    redirect_to user_url(current_user)
  end

  def edit
    @lawschool_detail = LawschoolDetail.find(params[:id])
  end

  def update
    current_user.user_detail.lawschool_detail = LawschoolDetail.new(lawschool_detail_params)
    if current_user.user_detail.save
      redirect_to user_url(current_user)
    else
      render :new
    end
  end

  private
  def lawschool_detail_params
    #todo - add
    params.require(:lawschool_detail).permit([:school_name, :year_graduated])
  end

end
