class Task < ApplicationRecord
    #バリデーション
    validates :title,   presence: true, length: { in: 1..150 }
    validates :content,                 length: { in: 0..100000 }
    validates :taskDate,presence: true
    validates :position,presence: true

    #アソシエーション
    belongs_to :calendar

    #カレンダーIDからTaskを取得して、配列に格納する関数
    def self.createDatekeyArrayOfTask(cal_id)
        taskResult = []
        tasks = self.where(calendar_id: cal_id)
        tasks.each do |task|
            dkArray = DateKeysArray.new
            taskResult = dkArray.createDateKeysArray(taskResult, task.taskDate)
            ins = {
                id:task.id,
                calendarId:cal_id,
                title:task.title,
                content:task.content,
                date:task.taskDate,
                position:task.position,
                complete:task.complete,
                label:"タスク"
            }
            taskResult[task.taskDate.strftime("%Y").to_i][task.taskDate.strftime("%m").to_i][task.taskDate.strftime("%d").to_i].push(ins)
        end
        return taskResult
    end
end
