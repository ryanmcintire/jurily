class UserDetail < ActiveRecord::Base
  belongs_to :user
  has_one :user_contact_info
  has_many :bar_admissions
  has_many :lawschool_details
  has_many :user_employments

  #todo - should I add
  accepts_nested_attributes_for :user_contact_info
  accepts_nested_attributes_for :bar_admissions
  accepts_nested_attributes_for :lawschool_details

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
