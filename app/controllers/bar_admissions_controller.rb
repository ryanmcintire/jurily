class BarAdmissionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @bar_admission = BarAdmission.new
  end

  def create

  end

end
