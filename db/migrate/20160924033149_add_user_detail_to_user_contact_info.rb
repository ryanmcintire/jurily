class AddUserDetailToUserContactInfo < ActiveRecord::Migration
  def change
    add_reference :user_contact_infos, :user_detail, index: true, foreign_key: true
  end
end
