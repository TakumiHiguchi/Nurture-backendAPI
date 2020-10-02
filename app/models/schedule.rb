class Schedule < ApplicationRecord
    #バリデーション
    validates :title,       :presence => true, :length => { :in => 1..150 }
    validates :CoNum,                       :length => { :in => 0..100 }
    validates :teacher,     :presence => true, :length => { :in => 1..30 }
    validates :semester,    :presence => true, :length => { :in => 1..3 }
    validates :position,    :presence => true
    validates :grade,       :presence => true
    validates :status,                      :length => { :in => 0..100 }

    #アソシエーション
    has_many :calendar_schedule_relations
    has_many :calendars, :through => :calendar_schedule_relations
    has_many :change_schedules

    def self.loadSchedule(cal_id)
        ins = Calendar.joins(:schedules).select("schedules.*, calendars.id AS cal_id, schedules.id AS sch_id, calendar_schedule_relations.*").where("calendars.id = ?", cal_id)
        result = (0...10).map { (0...2).map {(0..6).map {Array.new(6,0)}}} #スケジュール配列の作成し、0で初期化

        ins.each do |pas|
            insArray = {
                :id => pas.id,
                :title => pas.title,
                :CoNum => pas.CoNum,
                :teacher => pas.teacher,
                :semester => pas.semester,
                :position => pas.position,
                :grade => pas.grade,
                :status => pas.status,
                :calendarId => pas.cal_id,
                :scheduleId => pas.sch_id
            }
            position = pas.position
            if pas.semester == "前学期"
                result[(pas.reges_grade.to_i - 1)][0][position / 6][position % 6] = insArray
            else
                result[(pas.reges_grade.to_i - 1)][1][position / 6][position % 6] = insArray
            end
        end
        return result
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
