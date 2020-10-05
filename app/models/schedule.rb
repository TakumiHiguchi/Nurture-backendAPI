class Schedule < ApplicationRecord
  #バリデーション
  validates :site_id,     uniquness: { scope: [:title, :teacher, :semester, :position, :grade]  }
  validates :title,       :presence => true, :length => { :in => 1..150 }
  validates :CoNum,                          :length => { :in => 0..100 }
  validates :teacher,     :presence => true, :length => { :in => 1..30 }
  validates :semester,    :presence => true, :length => { :in => 1..3 }
  validates :position,    :presence => true
  validates :grade,       :presence => true
  validates :status,                      :length => { :in => 0..100 }

  #アソシエーション
  has_many :calendar_schedule_relations
  has_many :calendars, :through => :calendar_schedule_relations
  has_many :change_schedules

  def loadSchedule(schedule, calendar_id)
    insArray = {
      :id => self.id,
      :title => self.title,
      :CoNum => self.CoNum,
      :teacher => self.teacher,
      :semester => self.semester,
      :position => self.position,
      :grade => self.grade,
      :status => self.status,
      :calendarId => calendar_id,
      :scheduleId => self.id
    }
    position = self.position
    reges_grade = CalendarScheduleRelation.find_by(calendar_id: calendar_id,schedule_id: self.id).reges_grade.to_i 
    if self.semester == "前学期"
      schedule[(reges_grade - 1)][0][position / 6][position % 6] = insArray
    else
      schedule[(reges_grade - 1)][1][position / 6][position % 6] = insArray
    end
    return schedule
  end

  def create_schedule_hash
    return({
      :id => self.id,
      :title => self.title,
      :CoNum => self.CoNum,
      :teacher => self.teacher,
      :semester => self.semester,
      :position => self.position,
      :grade => self.grade,
      :status => self.status
    })
  end

  def self.searchAPI(type,params)
    return self.all unless params.to_s.length > 0

    case type
    when "fr" then
      keywords = params.split(/[[:blank:]]+/)
      schedules = self
      keywords.each do |keyword|
        schedules = schedules.where("UPPER(title) LIKE ?", "%#{keyword.upcase}%") #分割されたキーワードでの検索
      end
      schedules.uniq
    when "position" then
      self.where(:title => params)
    end
  end
end
