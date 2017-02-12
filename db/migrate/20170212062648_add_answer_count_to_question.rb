class AddAnswerCountToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.integer :answers_count, default: 0
    end

    reversible do |dir|
      dir.up {data}
    end
  end

  def data
    execute <<-SQL.squish
      UPDATE questions
        SET answers_count = (SELECT count(1) FROM answers where answers.question_id = questions.id)
    SQL
  end
end
