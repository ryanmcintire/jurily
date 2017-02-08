class Tag < ActiveRecord::Base

  has_many :question_tags
  has_many :questions, through: :question_tags

  scope :by_name, -> (name) { where(name: name)}

end
