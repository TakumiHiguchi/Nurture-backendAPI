class Exam < ApplicationRecord
  #バリデーション
  validates :title,   :presence => true, :length => { :in => 1..150 }
  validates :content,                 :length => { :in => 0..100000 }
  validates :examDate,:presence => true
  validates :position,:presence => true

  #アソシエーション
  belongs_to :calendar

  def self.uniq_create(props)
    errorJson = RenderErrorJson.new()
		check = self.find_by(:examDate => props[:examdate], :position => props[:position])
		if check.blank?
			return(
				self.create(
          :title => props[:title],
          :content => props[:content],
          :examDate => props[:examdate],
          :position => props[:position]
				)
			)
		else
			return nil
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
