require "#{Rails.root}/lib/enums/jurisdictions"

class Question < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]

  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable

  enum jurisdiction: Jurisdictions::JURISDICTIONS

  #todo - accommodate multiple jdx
  scope :jurisdiction, -> (jurisdiction) {where jurisdiction: Jurisdictions::JURISDICTIONS[jurisdiction
                                                                                               .to_s
                                                                                               .parameterize
                                                                                               .underscore
                                                                                               .downcase
                                                                                               .to_sym]}

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
