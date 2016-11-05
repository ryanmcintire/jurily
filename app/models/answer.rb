class Answer < ActiveRecord::Base
  include PgSearch
  multisearchable :against => :body

  belongs_to :question
  belongs_to :user
  #todo - evaluate how you want to delete votes eventually...
  has_many :votes, as: :votable, dependent: :destroy

  def score
    tally = 0
    self.votes.each {|vote| tally += vote.value}
    tally
  end

  def top_answer?
    self.question.top_answer.id == self.id
  end
end
