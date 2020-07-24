class Calendar < ApplicationRecord
    #バリデーション
    validates :key,         presence: true, length: { in: 1..512 }
    validates :name,        presence: true, length: { in: 1..150 }
    validates :description,                 length: { in: 0..100000 }

    #アソシエーション
    has_many :user_calendar_relations
    has_many :users, through: :user_calendar_relations
    has_many :calendar_schedule_relations
    has_many :schedules, through: :calendar_schedule_relations
    has_many :tasks
    has_many :exams
    has_many :change_schedules
    has_many :semester_periods
end
