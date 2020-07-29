class SemesterPeriod < ApplicationRecord
    #バリデーション
    validates :grade,           presence: true
    validates :fh_semester_f,   presence: true          
    validates :fh_semester_s,    presence: true
    validates :late_semester_f, presence: true
    validates :late_semester_s, presence: true

    #アソシエーション
    belongs_to :calendar


    def self.loadUserPeriod(cal_id)
        result = Array.new(10,{fhSemester1: "2020/4/10", fhSemester2: "2020/7/30", lateSemester1: "2020/9/14", lateSemester2: "2021/2/22"})
        self.where(calendar_id:cal_id).each do |period|
            ins = {fhSemester1: period.fh_semester_f.strftime("%Y/%m/%d"), fhSemester2: period.fh_semester_s.strftime("%Y/%m/%d"), lateSemester1:period.late_semester_f.strftime("%Y/%m/%d"), lateSemester2:period.late_semester_s.strftime("%Y/%m/%d")}
            result[period.grade - 1] = ins
        end
        
        return result
    end
    def self.clone(cal_id, newcal_id)
        periods = SemesterPeriod.where(calendar_id: cal_id)
        bl = true
        periods.each do |period|
            if bl
                bl = SemesterPeriod.create(
                    calendar_id:newcal_id,
                    grade:period.grade,
                    fh_semester_f:period.fh_semester_f, 
                    fh_semester_s: period.fh_semester_s, 
                    late_semester_f: period.late_semester_f, 
                    late_semester_s:period.late_semester_s
                )
            end
        end
        return bl
    end
end
