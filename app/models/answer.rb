class Answer < ActiveRecord::Base
  include PgSearch
  multisearchable :against => :body

  belongs_to :question
  belongs_to :user
  has_many :votes, as: :votable

  def score
    tally = 0
    self.votes.each {|vote| tally += vote.value}
    tally
  end
end
