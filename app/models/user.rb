class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers
  has_one :user_detail
  has_one :filter

  accepts_nested_attributes_for :user_detail

  #virtual members for sign up form.
  attr_accessor :admitted, :tos_accepted

  def answer_score
    total_score = 0
    self.answers.each {|a| total_score += a.score}
    total_score
  end

  def question_score
    total_score = 0
    self.questions.each {|q| total_score += q.score}
    total_score
  end

  def top_answer_count
    count = 0
    self.answers.each do |a|
      count += 1 if a.top_answer?
    end
    count
  end

  def recent_questions(limit)
    self.questions.order(created_at: :desc).limit(limit)
  end

  def top_questions(limit)
    self.questions.sort_by {|q| q.score}.reverse[0..(limit-1)]
  end

  def recent_answers(limit)
    self.answers.order(created_at: :desc).limit(limit)
  end

  def top_answers(limit)
    self.answers.sort_by {|a| a.score}.reverse[0..(limit-1)]
  end

end
