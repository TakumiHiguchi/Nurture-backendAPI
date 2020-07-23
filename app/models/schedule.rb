class Schedule < ApplicationRecord
    #バリデーション
    validates :title,       presence: true, length: { in: 1..150 }
    validates :CoNum,                       length: { in: 0..100 }
    validates :teacher,     presence: true, length: { in: 1..30 }
    validates :semester,    presence: true, length: { in: 1..3 }
    validates :position,    presence: true
    validates :grade,       presence: true
    validates :status,                      length: { in: 0..100 }

    #アソシエーション
    has_many :schedule_calendar_relations
    has_many :calendars, through: :schedule_calendar_relations
    has_many :change_schedules
    
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
            self.where(title: params)
        end
    end
end
