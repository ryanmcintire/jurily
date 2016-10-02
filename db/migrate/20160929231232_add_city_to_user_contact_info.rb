class AddCityToUserContactInfo < ActiveRecord::Migration
  def change
    add_column :user_contact_infos, :city, :string
  end
end
