class ChangeSchedule < ApplicationRecord
	# スキーマ
	# schedule_id(integer)
	# calendar_id(integer)
	# beforeDate(date)
	# afterDate(date)
	# position(integer)
	# created_at(datetime)  :precision => 6, :null => false
  # updated_at(datetime)  :precision => 6, :null => false

  # バリデーション
  validates :position,    :presence => true

  # アソシエーション
  belongs_to :schedule, optional: true
  belongs_to :calendar, optional: true
    
	def self.uniq_create(props)
		errorJson = RenderErrorJson.new()
		# 日付を加工する
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
	
	def clone(newcalendar_id)
		ChangeSchedule.create(
			:calendar_id => newcalendar_id, 
			:schedule_id => self.schedule_id, 
			:beforeDate => self.beforeDate, 
			:afterDate => self.afterDate, 
			:position => self.position
		)
  end
end
