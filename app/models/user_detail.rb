class UserDetail < ActiveRecord::Base
  has_one :user_contact_info
end
