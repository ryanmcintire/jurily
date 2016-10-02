class RemoveStreetFromUserContactInfo < ActiveRecord::Migration
  def change
    remove_column :user_contact_infos, :street
  end
end
