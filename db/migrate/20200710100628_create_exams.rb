class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.date :examDate
      t.integer :position

      t.timestamps
    end
  end
end
