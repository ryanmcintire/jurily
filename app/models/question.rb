require "#{Rails.root}/lib/enums/jurisdictions"

class Question < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]

  validates :title, :body, :jurisdiction, presence: true
  validates :title, length: {in: 6..250} #todo - eval length.

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_and_belongs_to_many :tags

  enum jurisdiction: Jurisdictions::JURISDICTIONS

  #todo - master this concept...
  #scope :top, joins('left join votes on votes.votable_id = votable_id')
  # scope :top, joins('left join votes on votes.for_id = profiles.user_id').
  #     select('profiles.*, count(votes.id) as votes_count').
  #     group('profiles.id').
  #     order('votes_count desc')


  scope :jurisdiction, -> (jurisdiction) { where jurisdiction: Jurisdictions::JURISDICTIONS[jurisdiction
                                                                                                .to_s
                                                                                                .parameterize
                                                                                                .underscore
                                                                                                .downcase
                                                                                                .to_sym] }

  def top_answer
    self.answers_descending[0]
  end

  def answers_descending
    self.answers.sort_by { |answer| answer.score }.reverse
  end

  def score
    tally = 0
    self.votes.each { |vote| tally += vote.value }
    tally
  end

  def self.get_jdx(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end

  def self.questions_by_jurisdiction(jurisdictions)
    Question.where(jurisdiction: jurisdictions.map { |j| Question.jurisdictions[j] })
  end

  def self.recent_questions
    Question.order('created_at DESC')
  end

  def self.recent_interest
    #todo - update query to exclude results greater than one month
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' and votes.created_at >= (now() - interval '1 month') then votes.value else 0 end) vote_score")
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  def self.top_ranked_questions
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' then votes.value else 0 end) vote_score")
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  private
  def jdx_enum_val(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end


end
