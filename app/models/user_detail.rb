class UserDetail < ActiveRecord::Base
  belongs_to :user
  has_one :user_contact_info
end
