class TransferSchedule < ApplicationRecord

  #アソシエーション
  belongs_to :calendar

  def loadCL(transfer_schedules_before, transfer_schedules_after, calendar_id)
    dkArray = DateKeysArray.new
    transfer_schedules_before = dkArray.createDateKeysArray(transfer_schedules_before, self.beforeDate)
    transfer_schedules_after = dkArray.createDateKeysArray(transfer_schedules_after, self.afterDate)
    insCl = {
      :calendar_id => calendar_id, 
      :beforeDate => self.beforeDate, 
      :afterDate => self.afterDate,
      :label => "振替"
    }
    transfer_schedules_before[self.beforeDate.strftime("%Y").to_i][self.beforeDate.strftime("%m").to_i][self.beforeDate.strftime("%d").to_i].push(insCl)
    transfer_schedules_after[self.afterDate.strftime("%Y").to_i][self.afterDate.strftime("%m").to_i][self.afterDate.strftime("%d").to_i].push(insCl)
    return transfer_schedules_before, transfer_schedules_after
  end

  def self.check_and_create(cal_id, beforeDate, afterDate)
      #日付を加工する
      beforeDate.gsub!("/","-")
      afterDate.gsub!("/","-")
      
      #すでに移動済みかのチェック
      check = TransferSchedule.where(:calendar_id => cal_id, :beforeDate => beforeDate)
      
      if check.length > 0
          result = nil
          mes = "振替は既にされています。"
          return result,mes
      else
          result = self.create(:calendar_id => cal_id, :beforeDate => beforeDate, :afterDate => afterDate)
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
      csrs = TransferSchedule.where(:calendar_id => cal_id)
      bl = true
      csrs.each do |csr|
          if bl
              bl = TransferSchedule.create(
                      :calendar_id => newcal_id, 
                      :beforeDate => csr.beforeDate,
                      :afterDate => csr.afterDate
                  )
          end
      end
      return bl
  end
end
