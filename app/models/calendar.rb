class Calendar < ApplicationRecord
    #バリデーション
    validates :key,         presence: true, length: { in: 1..512 }
    validates :name,        presence: true, length: { in: 1..150 }
    validates :description,                 length: { in: 0..100000 }

    #アソシエーション
    has_many :user_calendar_relations
    has_many :users, through: :user_calendar_relations
    has_many :calendar_schedule_relations, dependent: :destroy
    has_many :schedules, through: :calendar_schedule_relations
    has_many :tasks, dependent: :destroy
    has_many :exams, dependent: :destroy
    has_many :change_schedules, dependent: :destroy
    has_many :semester_periods, dependent: :destroy

end
