class ChangeSchedule < ApplicationRecord
    belongs_to :schedule
    
    validates :beforeDate, presence: true
    validates :afterDate, presence: true
    validates :position, presence: true
    validates :user_id, presence: true
    validates :schedule_id, presence: true
    
    def self.check_and_create(user_id, schedule_id, beforeDate, afterDate, position)
        #日付を加工する
        beforeDate.gsub!("/","-")
        afterDate.gsub!("/","-")
        
        #すでに移動済みかのチェック
        check = ChangeSchedule.joins(:schedule).select("change_schedules.* ,schedules.*").where(user_id:user_id, schedule_id:schedule_id, beforeDate:beforeDate).where("schedules.id LIKE ?", schedule_id)
        check1 = ChangeSchedule.where(user_id:user_id,afterDate:afterDate, position:position)
        
        if check.length > 0
            result = nil
            mes = "授業は既に移動されています。"
            return result,mes
        elsif check1.length > 0
            result = nil
            mes = "移動先には授業変更が既に登録されています。"
            return result,mes
        else
            result = self.create(user_id:user_id, schedule_id:schedule_id, beforeDate:beforeDate, afterDate:afterDate, position:position)
            result = result.save
            if result
                mes = "授業の移動を作成しました"
            else
                mes = "授業の移動に失敗しました"
            end
            return result,mes
        end
        
        
    end
end
