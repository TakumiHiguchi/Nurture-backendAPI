class Schedule < ApplicationRecord
    has_many :user_schedule_relations
    has_many :users, through: :user_schedule_relations
    has_many :change_schedules
    
    validates :title, length: { in: 1..150 }
    validates :teacher, length: { in: 1..30 }
    validates :semester, length: { in: 1..10 }
    
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
