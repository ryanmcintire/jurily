class QuestionTag < ActiveRecord::Base
  validates_presence_of :question, :tag

  belongs_to :question
  belongs_to :tag

end