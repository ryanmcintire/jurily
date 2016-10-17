require "#{Rails.root}/lib/enums/jurisdictions"

class Question < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]

  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable

  enum jurisdiction: Jurisdictions::JURISDICTIONS

  def score
    tally = 0
    self.votes.each {|vote| tally += vote.value}
    tally
  end

end
