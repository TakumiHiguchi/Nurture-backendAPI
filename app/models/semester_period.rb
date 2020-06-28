class SemesterPeriod < ApplicationRecord
    
    def self.loadUserPeriod(user_id)
        result = Array.new(10,{fhSemester1: "2020/1/1", fhSemester2: "2020/4/1", lateSemester1: "2020/8/1", lateSemester2: "2020/12/1"})
        self.where(user_id:user_id).each do |period|
            ins = {fhSemester1: period.fh_semester_f.strftime("%Y/%m/%d"), fhSemester2: period.fh_semester_s.strftime("%Y/%m/%d"), lateSemester1:period.late_semester_f.strftime("%Y/%m/%d"), lateSemester2:period.late_semester_s.strftime("%Y/%m/%d")}
            result[period.grade - 1] = ins
        end
        
        return result
    end
end
