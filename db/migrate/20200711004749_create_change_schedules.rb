class CreateChangeSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :change_schedules do |t|
      t.integer :schedule_id
      t.integer :user_id
      t.date :beforeDate
      t.date :afterDate
      t.integer :position
      
      t.timestamps
    end
  end
end
