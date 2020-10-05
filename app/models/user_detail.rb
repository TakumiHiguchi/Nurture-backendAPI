class UserDetail < ApplicationRecord
  #バリデーション
  validates :name,    :presence => true
  validates :grade,   :presence => true

  #アソシエーション
  belongs_to :user
end
