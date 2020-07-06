class CreateUserTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.date :taskDate
      t.integer :position

      t.timestamps
    end
  end
end
