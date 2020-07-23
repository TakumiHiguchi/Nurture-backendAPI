class User < ApplicationRecord
    #バリデーション
    validates :key,        presence: true, length: { maximum: 512 }

    #アソシエーション
    has_many :user_calendar_relations
    has_many :calendars, through: :user_calendar_relations
    has_many :user_details
    
    
    def self.exists_and_create(key,ses)
        maxAge = Time.now.to_i + 3600
        if user = self.find_by(key:key)
            return user.update(session:ses, maxAge:maxAge) ,true ,maxAge
        else
            return self.create(key:key, session:ses, maxAge:maxAge), false ,maxAge
        end
    end
end
