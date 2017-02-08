class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :question_tags do |t|
      t.belongs_to :question, index: true
      t.belongs_to :tag, index: true
      t.timestamps null: false
    end
  end
end
