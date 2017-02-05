class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.text :jurisdictions
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :users, :filter, index: true
  end
end
