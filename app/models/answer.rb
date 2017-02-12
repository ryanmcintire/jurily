class Answer < ActiveRecord::Base
  include PgSearch
  before_create :randomize_id

  multisearchable :against => :body

  belongs_to :question, counter_cache: true
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

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(2_147_483_647)
    end while User.where(id: self.id).exists? || self.id < 1_000_000
  end
end
