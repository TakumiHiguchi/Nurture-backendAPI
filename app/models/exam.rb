class Exam < ApplicationRecord
    validates :title, length: { in: 1..150 }
    validates :content, length: { in: 0..100000 }
    validates :position, length: { in: 0..5 }
    
    def self.check_and_create(user_id, title, content, examDate, position)
        check = Exam.where(user_id:user_id, examDate:examDate, position:position)
        if check.length > 0
            return nil,"試験が既に存在するため、作成に失敗しました。"
        else
            result = self.create(user_id:user_id, title:title, content:content, examDate:examDate, position:position)
            return result.save,"試験を作成しました"
        end
    end
end
