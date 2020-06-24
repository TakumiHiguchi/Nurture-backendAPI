class CreateSemesterPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :semester_periods do |t|
      t.integer :user_id
      t.datetime :fh_semester_f
      t.datetime :fh_semester_s
      t.datetime :late_semester_f
      t.datetime :late_semmester_s

      t.timestamps
    end
  end
end
