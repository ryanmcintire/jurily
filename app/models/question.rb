class Question < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]

  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable


end
