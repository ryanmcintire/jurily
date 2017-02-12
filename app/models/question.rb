require "#{Rails.root}/lib/enums/jurisdictions"

class Question < ActiveRecord::Base
  include PgSearch

  multisearchable against: [:title, :body]
  pg_search_scope :search_title_body,
                  against: [:title, :body],
                  using: {
                      tsearch: {
                          highlight: {
                              start_sel: '<b>',
                              stop_sel: '</b>'
                          }
                      }
                  }
  # todo - associated_against + highlighting breaks search
  # todo - Will need to figure out a way to create a searchable object.
  # associated_against: {
  #     answers: :body
  # }

  before_create :randomize_id


  validates :title, :body, :jurisdiction, presence: true
  validates :title, length: {in: 6..250}

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :question_tags
  has_many :tags, through: :question_tags

  enum jurisdiction: Jurisdictions::JURISDICTIONS

  scope :jurisdiction, -> (jurisdiction) { where jurisdiction: Jurisdictions::JURISDICTIONS[jurisdiction
                                                                                                .to_s
                                                                                                .parameterize
                                                                                                .underscore
                                                                                                .downcase
                                                                                                .to_sym] }

  scope :by_tag_names, -> tag_names { joins(:tags).merge(Tag.by_name(tag_names)) }
  scope :by_jurisdictions, -> (*jurisdictions) { where(jurisdiction: jurisdictions.map { |j| Question.jurisdictions[j] }) }
  scope :sort_by_score, -> () {
    select("questions.*, SUM(case when votes.votable_type = 'Question' then votes.value else 0 end) vote_score").
        joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'").
        group("questions.id").
        order("vote_score DESC")
  }

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

  def self.recent
    Question.order('created_at DESC')
  end

  def self.recent_interest
    #todo - update query to exclude results greater than one month
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' and votes.created_at >= (now() - interval '1 month') then votes.value else 0 end) vote_score")
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  def self.top_ranked
    Question.select("questions.*, SUM(case when votes.votable_type = 'Question' then votes.value else 0 end) vote_score")
        .joins("LEFT OUTER JOIN votes ON votes.votable_id = questions.id and votes.votable_type = 'Question'")
        .group("questions.id")
        .order("vote_score DESC")
  end

  private
  def jdx_enum_val(jdx)
    Jurisdictions::JURISDICTIONS[jdx]
  end

  def randomize_id
    begin
      self.id = SecureRandom.random_number(2_147_483_647)
    end while User.where(id: self.id).exists? || self.id < 1_000_000
  end


end
