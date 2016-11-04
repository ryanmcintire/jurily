class AddOrgDetailsToUserDetail < ActiveRecord::Migration
  def change
    add_column :user_details, :organization, :string
    add_column :user_details, :title, :string
    add_column :user_details, :website_url, :string
    add_column :user_details, :linkedin_url, :string
  end
end
