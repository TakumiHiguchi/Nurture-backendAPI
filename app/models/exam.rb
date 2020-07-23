class Exam < ApplicationRecord
    #バリデーション
    validates :title,   presence: true, length: { in: 1..150 }
    validates :content,                 length: { in: 0..100000 }
    validates :examDate,presence: true
    validates :position,presence: true

    #アソシエーション
    belongs_to :calendar
    
    def self.check_and_create(user_id, title, content, examDate, position)
        check = Exam.where(user_id:user_id, examDate:examDate, position:position)
        if check.length > 0
            return nil,"試験が既に存在するため、作成に失敗しました。"
        else
            result = self.create(user_id:user_id, title:title, content:content, examDate:examDate, position:position)
            return result.save,"試験を作成しました"
        end
    end

    #カレンダーIDからExamを取得して、配列に格納する関数
    def self.createDatekeyArrayOfExam(cal_id)
        examResult = []
        exams = self.where(calendar_id: cal_id)
        exams.each do |exam|
            dkArray = DateKeysArray.new
            examResult = dkArray.createDateKeysArray(examResult, exam.examDate)
            ins = {
                id:exam.id,
                title:exam.title,
                content:exam.content,
                date:exam.examDate,
                position:exam.position,
                complete:exam.complete,
                label:"タスク"
            }
            examResult[exam.examDate.strftime("%Y").to_i][exam.examDate.strftime("%m").to_i][exam.examDate.strftime("%d").to_i].push(ins)
        end
        return examResult
    end
end
