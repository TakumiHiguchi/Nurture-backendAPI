class ChangeSchedule < ApplicationRecord
    #バリデーション
    validates :beforeDate,  presence: true
    validates :afterDate,   presence: true
    validates :position,    presence: true

    #アソシエーション
    belongs_to :schedule
    belongs_to :calendar
    
    
    def self.check_and_create(user_id, schedule_id, beforeDate, afterDate, position)
        #日付を加工する
        beforeDate.gsub!("/","-")
        afterDate.gsub!("/","-")
        
        #すでに移動済みかのチェック
        check = ChangeSchedule.joins(:schedule).select("change_schedules.* ,schedules.*").where(user_id:user_id, schedule_id:schedule_id, beforeDate:beforeDate)
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

    #カレンダーIDから授業変更を取得して、配列に格納する関数
    def self.createDatekeyArrayOfChangeSchedule(cal_id)
        changeSchedule = ChangeSchedule.joins(:calendar).select("change_schedules.* ,calendars.* ,change_schedules.position AS change_schedules_position, change_schedules.id AS change_schedules_id").where(calendar_id: cal_id)
        result = []
        result1 = []
        changeSchedule.each do |t|
            #年:月:日をkeyに持つhashを生成し、そこに試験内容をpushしていく
            dkArray = DateKeysArray.new
            result = dkArray.createDateKeysArray(result, t.afterDate)
            dkArray1 = DateKeysArray.new
            result1 = dkArray1.createDateKeysArray(result1, t.beforeDate)
            ins = {
                id:t.change_schedules_id,
                title:t.title,
                CoNum:t.CoNum,
                teacher:t.teacher,
                semester:t.semester,
                after_position:t.change_schedules_position,
                grade:t.grade,
                status:t.status,
                afterDate:t.afterDate
            }
            result[t.afterDate.strftime("%Y").to_i][t.afterDate.strftime("%m").to_i][t.afterDate.strftime("%d").to_i].push(ins)
            ins = {
                id:t.change_schedules_id,
                title:t.title,
                CoNum:t.CoNum,
                teacher:t.teacher,
                semester:t.semester,
                before_position:t.position,
                after_position:t.change_schedules_position,
                afterDate:t.afterDate,
                grade:t.grade,
                status:t.status,
                beforeDate:t.beforeDate
            }
            result1[t.beforeDate.strftime("%Y").to_i][t.beforeDate.strftime("%m").to_i][t.beforeDate.strftime("%d").to_i].push(ins)
        end
        return result,result1
    end
end
