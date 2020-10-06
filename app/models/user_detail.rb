class UserDetail < ApplicationRecord
  # スキーマ
  # user_id(integer)
  # name(string)
  # grade(integer)
  # created_at(datetime)  :precision => 6, :null => false
  # updated_at(datetime)  :precision => 6, :null => false

  #バリデーション
  validates :name,    :presence => true
  validates :grade,   :presence => true

  #アソシエーション
  belongs_to :user
end
