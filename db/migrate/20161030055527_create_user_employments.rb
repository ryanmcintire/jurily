class CreateUserEmployments < ActiveRecord::Migration
  def change
    create_table :user_employments do |t|
      t.string :title
      t.string :organization
      t.string :organization_website
      t.references :user_detail, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
