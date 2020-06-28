class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.string :title
      t.string :CoNum
      t.string :teacher
      t.string :semester
      t.integer :position
      t.integer :grade, default: 1
      t.string :status

      t.timestamps
    end
  end
end
