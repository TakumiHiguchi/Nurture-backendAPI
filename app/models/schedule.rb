class Schedule < ApplicationRecord
    
    
    
    
    
    
    
    def self.searchAPI(type,params)
        return self.all if params.empty?

        case type
        when "fr" then
            keywords = params.split(/[[:blank:]]+/)
            schedules = self
            
            keywords.each do |keyword|
                schedules = schedules.where("UPPER(title) LIKE ?", "%#{keyword.upcase}%") #分割されたキーワードでの検索
            end
            
            schedules.uniq
        when "title" then
            self.where(title: params)
        when "limit" then
            self.limit(params.to_i)
        end
    end
end
