class ChangeSchedule < ApplicationRecord
  #バリデーション
  validates :position,    :presence => true

  #アソシエーション
  belongs_to :schedule
  belongs_to :calendar
    
    
  def self.check_and_create(cal_id, schedule_id, beforeDate, afterDate, position)
    #日付を加工する
    beforeDate.gsub!("/","-")
    afterDate.gsub!("/","-")
  
    #すでに移動済みかのチェック
    check = ChangeSchedule.where(:calendar_id => cal_id, :schedule_id => schedule_id, :beforeDate => beforeDate)
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
	def self.createDatekeyArrayOfChangeSchedule(calendar_id)
		result = []
		result1 = []
		self.all.each do |cs|
			dkArray = DateKeysArray.new
			result = dkArray.createDateKeysArray(result, cs.afterDate)
			dkArray1 = DateKeysArray.new
			result1 = dkArray1.createDateKeysArray(result1, cs.beforeDate)

			insSchedule = Schedule.find_by(:id => cs.schedule_id);
			ins = {
				:id => cs.id,
				:calendarId => calendar_id,
				:title => insSchedule.title,
				:CoNum => insSchedule.CoNum,
				:teacher => insSchedule.teacher,
				:semester => insSchedule.semester,
				:after_position => cs.position,
				:grade => insSchedule.grade,
				:status => insSchedule.status,
				:afterDate => cs.afterDate
			}
			result[cs.afterDate.strftime("%Y").to_i][cs.afterDate.strftime("%m").to_i][cs.afterDate.strftime("%d").to_i].push(ins)
			ins = {
				:id => cs.id,
				:calendarId => calendar_id,
				:title => insSchedule.title,
				:CoNum => insSchedule.CoNum,
				:teacher => insSchedule.teacher,
				:semester => insSchedule.semester,
				:before_position => (insSchedule.position % 6).to_i,
				:after_position => cs.position,
				:afterDate => cs.afterDate,
				:grade => insSchedule.grade,
				:status => insSchedule.status,
				:beforeDate => cs.beforeDate
			}
			result1[cs.beforeDate.strftime("%Y").to_i][cs.beforeDate.strftime("%m").to_i][cs.beforeDate.strftime("%d").to_i].push(ins)
		end
		return result1,result
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
