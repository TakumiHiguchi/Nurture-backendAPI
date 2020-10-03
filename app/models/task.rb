class Task < ApplicationRecord
    #バリデーション
    validates :title,   :presence => true, :length => { :in => 1..150 }
    validates :content,                 :length => { :in => 0..100000 }
    validates :taskDate,:presence => true
    validates :position,:presence => true

    #アソシエーション
    belongs_to :calendar

    #カレンダーIDからTaskを取得して、配列に格納する
    def createDatekeyArrayOfTask(taskResult, calendar_id)
        dkArray = DateKeysArray.new
        taskResult = dkArray.createDateKeysArray(taskResult, self.taskDate)
        ins = {
          :id => self.id,
          :calendarId => calendar_id,
          :title => self.title,
          :content => self.content,
          :date => self.taskDate,
          :position => self.position,
          :complete => self.complete,
          :label => "タスク"
        }
        taskResult[self.taskDate.strftime("%Y").to_i][self.taskDate.strftime("%m").to_i][self.taskDate.strftime("%d").to_i].push(ins)
        return taskResult
    end
    def self.clone(cal_id, newcal_id)
        tasks = Task.where(:calendar_id => cal_id)
        bl = true
        tasks.each do |task|
            if bl
                bl = Task.create(
                    :calendar_id => newcal_id, 
                    :title => task.title, 
                    :content => task.content, 
                    :taskDate => task.taskDate, 
                    :position => task.position
                )
            end
        end
        return bl
    end
end
