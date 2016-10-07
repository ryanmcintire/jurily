class Question < ActiveRecord::Base
  include PgSearch

  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable


end
