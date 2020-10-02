class UserCalendarRelation < ApplicationRecord
    #バリデーション
    validates :user_id,     :presence => true
    validates :calendar_id, :presence => true

    #アソシエーション
    belongs_to :user
    belongs_to :calendar
    
end
