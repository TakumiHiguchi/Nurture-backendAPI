class CreateSemesterPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :semester_periods do |t|
      t.integer :user_id
      t.integer :grade
      t.date :fh_semester_f
      t.date :fh_semester_s
      t.date :late_semester_f
      t.date :late_semmester_s

      t.timestamps
    end
  end
end
