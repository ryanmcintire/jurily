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

  def title_display
    current_position = self.user_employments.where(date_end: nil).order(date_start: :desc).take(1)
    return current_position_stringified(current_position) unless (current_position.nil? || current_position.count == 0)
    most_recent_position = self.user_employments.order(date_end: :desc).take(1)
    return most_recent_position_stringified(most_recent_postiion) unless (most_recent_position.nil? || current_position.count == 0)
    student_detail = self.lawschool_detail
    return student_detail_stringified(student_detail) unless student_detail.nil?
    nil
  end

  private
  def current_position_stringified(current_position)
    return nil if current_position.nil?
    "#{current_position.position_title}, #{current_position.organization_name}"
  end

  def most_recent_position_stringified(most_recent_position)
    return nil if most_recent_position.nil?
    "#{most_recent_position.position_title}, #{current_position.organization_name}"
  end

  def student_detail_stringified(student_detail)
    return "Student, #{student_detail.school_name}" if student_detail.currently_attending
    return "Graduate, #{student_detail.school_name}" unless student_detail.year_graduated.nil?
    "Former Student, #{student_detail.school_name}"
  end
end
