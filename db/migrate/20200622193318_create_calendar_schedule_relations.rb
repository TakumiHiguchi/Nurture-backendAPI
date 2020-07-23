class CreateCalendarScheduleRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_schedule_relations do |t|
      t.integer :schedule_id
      t.integer :calendar_id
      t.integer :reges_grade
      
      t.timestamps
    end
  end
end
