class AddFieldsToUserContactInfo < ActiveRecord::Migration
  def change
    add_column :user_contact_infos, :address1, :string
    add_column :user_contact_infos, :address2, :string
    add_column :user_contact_infos, :street, :string
    add_column :user_contact_infos, :state, :string
    add_column :user_contact_infos, :zipcode, :string
  end
end
