class SemesterPeriod < ApplicationRecord
  # スキーマ
  # calendar_id(integer)
  # grade(integer)
  # fh_semester_f(date)
  # fh_semester_s(date)
  # late_semester_f(date)
  # late_semester_s(date)
  # created_at(datetime)  :precision => 6, :null => false
  # updated_at(datetime)  :precision => 6, :null => false

  #バリデーション
  validates :grade,           :presence => true
  validates :fh_semester_f,   :presence => true          
  validates :fh_semester_s,    :presence => true
  validates :late_semester_f, :presence => true
  validates :late_semester_s, :presence => true

  #アソシエーション
  belongs_to :calendar, optional: true

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

  def self.exsists_and_create(props)
    semester_period = self.find_by(:grade => props[:grade])
    if semester_period.nil?
      result = SemesterPeriod.create(
        :calendar_id => props[:calendarId],
        :grade => props[:grade],
        :fh_semester_f => props[:date1],
        :fh_semester_s => props[:date2],
        :late_semester_f => props[:date3],
        :late_semester_s => props[:date4]
      )
    else
      result = semester_period.update(
        :grade => props[:grade],
        :fh_semester_f => props[:date1],
        :fh_semester_s => props[:date2],
        :late_semester_f => props[:date3],
        :late_semester_s => props[:date4]
      )
    end
  end
end
