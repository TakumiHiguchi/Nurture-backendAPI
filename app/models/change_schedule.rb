class ChangeSchedule < ApplicationRecord
  #バリデーション
  validates :position,    :presence => true

  #アソシエーション
  belongs_to :schedule
  belongs_to :calendar
    
	def self.uniq_create(props)
		errorJson = RenderErrorJson.new()
		#日付を加工する
    props[:before].gsub!("/","-")
    props[:after].gsub!("/","-")
		check = self
			.where(:schedule_id => props[:schedule_id], :beforeDate => props[:before])
			.or(where(:position => props[:position], :afterDate => props[:after]))
		if check.blank?
			return(
				self.create(
					:schedule_id => props[:schedule_id], 
					:beforeDate => props[:before], 
					:afterDate => props[:after], 
					:position => props[:position]
				)
			)
		else
			return nil
		end
	end

	def self.check_and_create(cal_id, schedule_id, beforeDate, afterDate, position)
		#消す
    
  
    #すでに移動済みかのチェック
    check = ChangeSchedule.where(:calendar_id => cal_id, )
    check1 = ChangeSchedule.where(:calendar_id => cal_id,:afterDate => afterDate, :position => position)

    if check.length > 0
			result = nil
			mes = "授業は既に移動されています。"
			return result,mes
		elsif check1.length > 0
			result = nil
			mes = "移動先には授業変更が既に登録されています。"
			return result,mes
		else
			result = self.create(:calendar_id => cal_id, :schedule_id => schedule_id, :beforeDate => beforeDate, :afterDate => afterDate, :position => position)
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
	def createDatekeyArrayOfChangeSchedule(change_schedules_before, change_schedules_after, calendar_id)
		dkArray = DateKeysArray.new
		change_schedules_after = dkArray.createDateKeysArray(change_schedules_after, self.afterDate)
		change_schedules_before = dkArray.createDateKeysArray(change_schedules_before, self.beforeDate)

		#ここで複数回SQLが発行されている
		#こんな感じの→ SELECT "schedules".* FROM "schedules" WHERE "schedules"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
		#おそらく設計が間違っている（change_schedluesでincludeしてもcalendarからchange_schedluesをincludeできない）
		schedule = Schedule.find(self.schedule_id)

		ins = {
			:id => self.id,
			:calendarId => calendar_id,
			:title => schedule.title,
			:CoNum => schedule.CoNum,
			:teacher => schedule.teacher,
			:semester => schedule.semester,
			:after_position => self.position,
			:grade => schedule.grade,
			:status => schedule.status,
			:afterDate => self.afterDate
		}
		change_schedules_after[self.afterDate.strftime("%Y").to_i][self.afterDate.strftime("%m").to_i][self.afterDate.strftime("%d").to_i].push(ins)
		ins = {
			:id => self.id,
			:calendarId => calendar_id,
			:title => schedule.title,
			:CoNum => schedule.CoNum,
			:teacher => schedule.teacher,
			:semester => schedule.semester,
			:before_position => (schedule.position % 6).to_i,
			:after_position => self.position,
			:afterDate => self.afterDate,
			:grade => schedule.grade,
			:status => schedule.status,
			:beforeDate => self.beforeDate
		}
		change_schedules_before[self.beforeDate.strftime("%Y").to_i][self.beforeDate.strftime("%m").to_i][self.beforeDate.strftime("%d").to_i].push(ins)
		return change_schedules_before,change_schedules_after
	end
	
    def self.clone(cal_id, newcal_id)
        css = ChangeSchedule.where(:calendar_id => cal_id)
        bl = true
        css.each do |cs|
            if bl
                bl = ChangeSchedule.create(
                    :calendar_id => newcal_id, 
                    :schedule_id => cs.schedule_id, 
                    :beforeDate => cs.beforeDate, 
                    :afterDate => cs.afterDate, 
                    :position => cs.position
                )
            end
        end
        return bl
    end
end
