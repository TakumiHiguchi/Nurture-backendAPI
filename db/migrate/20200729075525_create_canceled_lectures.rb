class CreateCanceledLectures < ActiveRecord::Migration[6.0]
  def change
    create_table :canceled_lectures do |t|
      t.integer :calendar_id
      t.date :clDate
      t.integer :grade
      t.integer :position

      t.timestamps
    end
  end
end
