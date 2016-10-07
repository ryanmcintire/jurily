class BarAdmissionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @bar_admission = BarAdmission.new
  end

  def create
    bar_admission = bar_admission_params
    bar_admission[:jurisdiction].downcase!
    current_user.user_detail.bar_admissions << BarAdmission.new(bar_admission)
    if current_user.user_detail.save
      redirect_to user_url(current_user)
    else
      render :new
    end
  end

  def destroy
    @bar_admission = BarAdmission.find(params[:id])
    @bar_admission.destroy
    redirect_to user_url(current_user)
  end

  def edit
    @bar_admission = BarAdmission.find(params[:id])
  end

  def update
    bar_admission = BarAdmission.find(params[:id])
    ba_params = bar_admission_params
    ba_params[:jurisdiction].downcase!
    redirect_to edit_bar_admission_url(bar_admission) and return unless BarAdmission.jurisdictions.has_key?(ba_params[:jurisdiction])
    bar_admission.update(bar_admission_params)
    if bar_admission.save
      redirect_to user_url(current_user)
    else
      render :new
    end
  end

  private
  def bar_admission_params
    params.require(:bar_admission).permit([:jurisdiction, :bar_number, :date_admitted])
  end

  #todo - get validation of enums

end
