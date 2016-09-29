require "#{Rails.root}/lib/enums/bar_admission_status"
require "#{Rails.root}/lib/enums/jurisdictions"

class BarAdmission < ActiveRecord::Base
  belongs_to :user_detail
  enum status: BarAdmissionStatus::STATUSES
  enum jurisdiction: Jurisdictions::JURISDICTIONS
end
