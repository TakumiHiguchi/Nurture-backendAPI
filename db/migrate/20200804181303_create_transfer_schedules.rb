class CreateTransferSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :transfer_schedules do |t|
      t.integer :calendar_id
      t.date :beforeDate
      t.date :afterDate

      t.timestamps
    end
  end
end
