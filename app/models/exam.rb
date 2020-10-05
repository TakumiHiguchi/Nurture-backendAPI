class Exam < ApplicationRecord
  #バリデーション
  validates :title,   :presence => true, :length => { :in => 1..150 }
  validates :content,                 :length => { :in => 0..100000 }
  validates :examDate,:presence => true
  validates :position,:presence => true

  #アソシエーション
  belongs_to :calendar

  def self.check_and_create(cal_id, title, content, examDate, position)
    check = Exam.where(:calendar_id => cal_id, :examDate => examDate, :position => position)
    if check.length > 0
      return nil,"試験が既に存在するため、作成に失敗しました。"
    else
      result = self.create(:calendar_id => cal_id, :title => title, :content => content, :examDate => examDate, :position => position)
      return result.save,"試験を作成しました"
    end
  end

  #Examを取得して、配列に格納する
  def createDatekeyArrayOfTask(examResult, calendar_id)
    dkArray = DateKeysArray.new
    examResult = dkArray.createDateKeysArray(examResult, self.examDate)
    ins = {
      :id => self.id,
      :calendarId => calendar_id,
      :title => self.title,
      :content => self.content,
      :date => self.examDate,
      :position => self.position,
      :complete => self.complete,
      :label => "タスク"
    }
    examResult[self.examDate.strftime("%Y").to_i][self.examDate.strftime("%m").to_i][self.examDate.strftime("%d").to_i].push(ins)
    return examResult
  end

  def clone(newcalender_id)
    Exam.create(
      :calendar_id => newcalender_id, 
      :title => self.title, 
      :content => self.content, 
      :examDate => self.examDate, 
      :position => self.position
    )
  end
end
