class TransferSchedule < ApplicationRecord
  # スキーマ
  # calendar_id(integer)
  # beforeDate(date)
  # afterDate(date)
  # created_at(datetime)  :precision => 6, :null => false
  # updated_at(datetime)  :precision => 6, :null => false

  #アソシエーション
  belongs_to :calendar, optional: true

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

  def self.uniq_create(props)
    #日付を加工する
    props[:before].gsub!("/","-")
    props[:after].gsub!("/","-")

    if self.find_by(:beforeDate => props[:before])
      self.create(
        :beforeDate => props[:before],
        :afterDate => props[:after]
      )
    else
      return nil
    end
  end

  def clone(newcalendar_id)
    TransferSchedule.create(
      :calendar_id => newcalendar_id, 
      :beforeDate => self.beforeDate,
      :afterDate => self.afterDate
    )
  end
end
