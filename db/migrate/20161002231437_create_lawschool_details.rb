class CreateLawschoolDetails < ActiveRecord::Migration
  def change
    create_table :lawschool_details do |t|
      t.string :school_name
      t.boolean :currently_attending
      t.references :user_detail, index: true, foreign_key: true
      t.date :year_graduated

      t.timestamps null: false
    end
  end
end
