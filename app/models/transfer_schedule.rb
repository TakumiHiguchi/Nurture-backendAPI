class TransferSchedule < ApplicationRecord
    def self.loadCL(cal_id)
        ins = self.where(calendar_id:cal_id)
        result = []
        result1 = []
        ins.each do |pas|
            dkArray = DateKeysArray.new
            result = dkArray.createDateKeysArray(result, pas.afterDate)
            insCl = {
                calendar_id:cal_id, 
                beforeDate:pas.beforeDate, 
                afterDate:pas.afterDate,
                label:"振替"
            }
            result[pas.afterDate.strftime("%Y").to_i][pas.afterDate.strftime("%m").to_i][pas.afterDate.strftime("%d").to_i].push(insCl)

        end
        ins.each do |pas|
            dkArray = DateKeysArray.new
            result1 = dkArray.createDateKeysArray(result1, pas.beforeDate)
            insCl = {
                calendar_id:cal_id, 
                beforeDate:pas.beforeDate, 
                afterDate:pas.afterDate,
                label:"振替"
            }
            result1[pas.beforeDate.strftime("%Y").to_i][pas.beforeDate.strftime("%m").to_i][pas.beforeDate.strftime("%d").to_i].push(insCl)

        end
        
        return result,result1
    end

    def self.check_and_create(cal_id, beforeDate, afterDate)
        #日付を加工する
        beforeDate.gsub!("/","-")
        afterDate.gsub!("/","-")
        
        #すでに移動済みかのチェック
        check = TransferSchedule.where(calendar_id:cal_id, beforeDate:beforeDate)
        
        if check.length > 0
            result = nil
            mes = "振替は既にされています。"
            return result,mes
        else
            result = self.create(calendar_id:cal_id, beforeDate:beforeDate, afterDate:afterDate)
            result = result.save
            if result
                mes = "振替を作成しました"
            else
                mes = "振替の作成に失敗しました"
            end
            return result,mes
        end
    end
    def self.clone(cal_id, newcal_id)
        csrs = TransferSchedule.where(calendar_id: cal_id)
        bl = true
        csrs.each do |csr|
            if bl
                bl = TransferSchedule.create(
                        calendar_id: newcal_id, 
                        beforeDate: csr.beforeDate,
                        afterDate:csr.afterDate
                    )
            end
        end
        return bl
    end
end
