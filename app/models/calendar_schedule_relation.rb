class CalendarScheduleRelation < ApplicationRecord
  #バリデーション
  validates :schedule_id, :presence => true
  validates :calendar_id, :presence => true

  #アソシエーション
  belongs_to :calendar
  belongs_to :schedule
  
  def self.uniq_create(props)
    if props[:schedule].present?
      if self.find_by(:schedule_id => props[:schedule].id, :calendar_id => props[:calendarId], :reges_grade => props[:user_grade]).nil?
        self.create(
          :schedule_id => props[:schedule].id,
          :calendar_id => props[:calendar_id],
          :reges_grade => props[:reges_grade]
        )
        return true
      end
    end
    return false
  end

  def clone(newcalendar_id)
    CalendarScheduleRelation.create(
      :schedule_id => self.schedule_id, 
      :calendar_id => newcalendar_id, 
      :reges_grade => self.reges_grade
    )
  end
end
