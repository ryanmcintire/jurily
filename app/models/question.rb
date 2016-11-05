require "#{Rails.root}/lib/enums/jurisdictions"

class Question < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]

  validates :title, :body, :jurisdiction, presence: true
  validates :title, length: {in: 6..250}  #todo - eval length.

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  enum jurisdiction: Jurisdictions::JURISDICTIONS

  #todo - accommodate multiple jdx
  scope :jurisdiction, -> (jurisdiction) {where jurisdiction: Jurisdictions::JURISDICTIONS[jurisdiction
                                                                                               .to_s
                                                                                               .parameterize
                                                                                               .underscore
                                                                                               .downcase
                                                                                               .to_sym]}

  def top_answer
    self.answers_descending[0]
  end

  def answers_descending
    self.answers.sort_by {|answer| answer.score}.reverse
  end

  def score
    tally = 0
    self.votes.each {|vote| tally += vote.value}
    tally
  end

  def self.get_jdx(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end

  private
  def jdx_enum_val(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end

end
