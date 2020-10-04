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

  def clone(newcalender_id)
    Task.create(
      :calendar_id => newcalender_id, 
      :title => self.title, 
      :content => self.content, 
      :taskDate => self.taskDate, 
      :position => self.position
    )
  end
end
