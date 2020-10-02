class UserDetail < ApplicationRecord
    #バリデーション
    validates :name,    :presence => true
    validates :grade,   :presence => true
    #アソシエーション
    belongs_to :user


    def setSchedule(user_id)
        result = (0...10).map {(0...2).map {(0..6).map {Array.new(6,0)}}} #スケジュール配列の作成し、0で初期化
        
        #ユーザーのスケジュールを取得
        schedule = User.joins(:schedules).select('users.*, schedules.*, user_schedule_relations.*, schedules.id AS schedule_id').where("users.id = ?", user_id)
        
        schedule.each do |sc|
            position = sc.position
            if sc.semester == "前学期"
                ins = { :id => sc.schedule_id, :title => sc.title, :CoNum => sc.CoNum, :teacher => sc.teacher, :semester => sc.semester, :position => sc.position, :grade => sc.grade, :status => sc.status }
                result[(sc.reges_grade.to_i - 1)][0][position / 6][position % 6] = ins
            else
                ins = { :id => sc.schedule_id, :title => sc.title, :CoNum => sc.CoNum, :teacher => sc.teacher, :semester => sc.semester, :position => sc.position, :grade => sc.grade, :status => sc.status }
                result[(sc.reges_grade.to_i - 1)][1][position / 6][position % 6] = ins
            end
        end
        
        mes= "ユーザーのスケジュールをレスポンスしました。"
        
        return result,mes
    end
    
end
