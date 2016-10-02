class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers
  has_one :user_detail

  accepts_nested_attributes_for :user_detail

  #virtual members for sign up form.
  attr_accessor :admitted, :tos_accepted


end
