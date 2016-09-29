class AddFirstNameLastNameToUserDetail < ActiveRecord::Migration
  def change
    add_column :user_details, :first_name, :string
    add_column :user_details, :last_name, :string
  end
end
