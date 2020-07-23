class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :calendar_id
      t.string :title
      t.text :content
      t.date :taskDate
      t.integer :position
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
