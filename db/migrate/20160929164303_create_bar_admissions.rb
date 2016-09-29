class CreateBarAdmissions < ActiveRecord::Migration
  def change
    create_table :bar_admissions do |t|
      t.references :user_detail, index: true, foreign_key: true
      t.date :date_admitted
      t.integer :status

      t.timestamps null: false
    end
  end
end
