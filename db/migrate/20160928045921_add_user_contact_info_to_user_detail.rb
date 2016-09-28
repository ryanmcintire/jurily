class AddUserContactInfoToUserDetail < ActiveRecord::Migration
  def change
    add_reference :user_details, :user_contact_info, index: true, foreign_key: true
  end
end
