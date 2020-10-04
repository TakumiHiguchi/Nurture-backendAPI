class SemesterPeriod < ApplicationRecord
  #バリデーション
  validates :grade,           :presence => true
  validates :fh_semester_f,   :presence => true          
  validates :fh_semester_s,    :presence => true
  validates :late_semester_f, :presence => true
  validates :late_semester_s, :presence => true

  #アソシエーション
  belongs_to :calendar

  def self.clone(cal_id, newcal_id)
    periods = SemesterPeriod.where(:calendar_id => cal_id)
    bl = true
    periods.each do |period|
      if bl
        bl = SemesterPeriod.create(
          :calendar_id => newcal_id,
          :grade => period.grade,
          :fh_semester_f => period.fh_semester_f, 
          :fh_semester_s => period.fh_semester_s, 
          :late_semester_f => period.late_semester_f, 
          :late_semester_s => period.late_semester_s
        )
      end
    end
    return bl
  end
end
