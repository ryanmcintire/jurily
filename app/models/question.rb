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

  #todo - master this concept...
  #scope :top, joins('left join votes on votes.votable_id = votable_id')
  # scope :top, joins('left join votes on votes.for_id = profiles.user_id').
  #     select('profiles.*, count(votes.id) as votes_count').
  #     group('profiles.id').
  #     order('votes_count desc')


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

  def self.recent_interest
    Question.select("questions.*, SUM(CASE WHEN (votes.votable_type = 'Question') AND (votes.created_at >= #{Time.now.beginning_of_month} ) THEN votes.value ELSE 0 END) vote_score", '2016-12-01')
        .joins("INNER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  def self.top_ranked_questions
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' then votes.value else 0 end) vote_score")
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  #test method for limiting by array of jdx.
  #use this as base for other methods as POC, but not to be used elsewhere.
  def self.test_jdx(jdx)
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' then votes.value else 0 end) vote_score")
        .where(jurisdiction: jdx)
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  private
  def jdx_enum_val(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end


end
