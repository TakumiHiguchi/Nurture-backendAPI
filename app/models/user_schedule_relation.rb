class UserScheduleRelation < ApplicationRecord
    belongs_to :user
    belongs_to :schedule
    
    def self.exists_and_create(user_id, sc, user_grade)
        if sc
            #スケジュールがある場合
            reSc = User.joins(:schedules).select("users.*, schedules.*, user_schedule_relations.reges_grade").where("users.id = ?", user_id).where("schedules.position = ?", sc.position).where("schedules.semester = ?", sc.semester).where("user_schedule_relations.reges_grade = ?", user_grade)
            
            if reSc.length > 0
                return nil,false,"既に登録されています。"
            else
                return self.create(schedule_id: sc.id, user_id: user_id, reges_grade: user_grade),true,"スケジュールの登録が完了しました。"
            end
        else
            #スケジュールがなかった場合の処理
            return nil,false,"スケジュールがありませんでした。"
        end
    end
end
