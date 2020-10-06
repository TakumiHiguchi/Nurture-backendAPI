class UserCalendarRelation < ApplicationRecord
  #スキーマ
  # user_id(integer)
  # calendar_id(integer)
  # created_at(datetime)  :precision => 6, :null => false
  # updated_at(datetime)  :precision => 6, :null => false

  #バリデーション
  validates :user_id,     :presence => true
  validates :calendar_id, :presence => true

  #アソシエーション
  belongs_to :user
  belongs_to :calendar
end
