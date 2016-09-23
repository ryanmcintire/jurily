class AddFieldsToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :title, :string
    add_column :questions, :body, :string
    add_reference :questions, :user, index: true, foreign_key: true
  end
end
