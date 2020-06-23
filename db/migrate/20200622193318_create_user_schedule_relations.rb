class CreateUserScheduleRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_schedule_relations do |t|
      t.integer :schedule_id
      t.integer :user_id
      t.integer :reges_grade
      
      t.timestamps
    end
  end
end
