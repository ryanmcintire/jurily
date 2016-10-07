class Answer < ActiveRecord::Base
  include PgSearch

  belongs_to :question
  belongs_to :user
  has_many :votes, as: :votable
end
