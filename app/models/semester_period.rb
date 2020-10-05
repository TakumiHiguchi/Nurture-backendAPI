class SemesterPeriod < ApplicationRecord
  #バリデーション
  validates :grade,           :presence => true
  validates :fh_semester_f,   :presence => true          
  validates :fh_semester_s,    :presence => true
  validates :late_semester_f, :presence => true
  validates :late_semester_s, :presence => true

  #アソシエーション
  belongs_to :calendar

  def clone(newcalendar_id)
    SemesterPeriod.create(
      :calendar_id => newcalendar_id,
      :grade => self.grade,
      :fh_semester_f => self.fh_semester_f, 
      :fh_semester_s => self.fh_semester_s, 
      :late_semester_f => self.late_semester_f, 
      :late_semester_s => self.late_semester_s
    )
  end
end
