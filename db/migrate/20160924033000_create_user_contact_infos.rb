class CreateUserContactInfos < ActiveRecord::Migration
  def change
    create_table :user_contact_infos do |t|

      t.timestamps null: false
    end
  end
end
