class AddQuestionToUser < ActiveRecord::Migration
  def change
    add_reference :users, :question, index: true, foreign_key: true
  end
end
