class CanceledLecture < ApplicationRecord
    def self.loadCL(cal_id)
        ins = self.where(calendar_id:cal_id)
        result = []
        ins.each do |pas|
            dkArray = DateKeysArray.new
            result = dkArray.createDateKeysArray(result, pas.clDate)
            insCl = {
                id:pas.id,
                calendarId:cal_id,
                date:pas.clDate,
                grade:pas.grade,
                position:pas.position,
                label:"休講"
            }
            result[pas.clDate.strftime("%Y").to_i][pas.clDate.strftime("%m").to_i][pas.clDate.strftime("%d").to_i].push(insCl)

        end
        return result
    end
end
