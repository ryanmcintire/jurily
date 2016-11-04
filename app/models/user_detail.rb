class UserDetail < ActiveRecord::Base
  belongs_to :user
  has_one :user_contact_info
  has_many :bar_admissions
  has_one :lawschool_detail
  has_many :user_employments

  #todo - showuld I add
  accepts_nested_attributes_for :user_contact_info
  accepts_nested_attributes_for :bar_admissions
  accepts_nested_attributes_for :lawschool_detail

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def current_title

  end

  def display_title
    return "#{self.title}, #{self.organization}" unless self.title.blank? or self.organization.blank?
    return "#{self.title}" unless self.title.blank?
    return "#{self.organization}" unless self.organization.blank?
    "No position specified"
  end
  alias_method :title_display, :display_title

  private
end
