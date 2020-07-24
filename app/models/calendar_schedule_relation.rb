class CalendarScheduleRelation < ApplicationRecord
    #バリデーション
    validates :schedule_id, presence: true
    validates :calendar_id, presence: true

    #アソシエーション
    belongs_to :calendar
    belongs_to :schedule
    
    def self.exists_and_create(calendar_id, sc, user_grade)
        if sc
            #スケジュールがある場合
            reSc = Calendar.joins(:schedules).select("calendars.*, schedules.*, calendar_schedule_relations.reges_grade").where("calendars.id = ?", calendar_id).where("schedules.position = ?", sc.position).where("schedules.semester = ?", sc.semester).where("calendar_schedule_relations.reges_grade = ?", user_grade)
            if reSc.length > 0
                return nil,false,"既に登録されています。"
            else
                return self.create(schedule_id: sc.id, calendar_id: calendar_id, reges_grade: user_grade),true,"スケジュールの登録が完了しました。"
            end
        else
            #スケジュールがなかった場合の処理
            return nil,false,"スケジュールがありませんでした。"
        end
    end
end
