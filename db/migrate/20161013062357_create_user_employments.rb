class CreateUserEmployments < ActiveRecord::Migration
  def change
    create_table :user_employments do |t|
      t.references :user_detail, index: true, foreign_key: true
      t.string :organization_name
      t.date :date_start
      t.date :date_end
      t.string :position_title

      t.timestamps null: false
    end
  end
end
