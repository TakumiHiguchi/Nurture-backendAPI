class Schedule < ApplicationRecord
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
