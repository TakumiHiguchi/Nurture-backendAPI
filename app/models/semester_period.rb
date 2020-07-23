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
        result = Array.new(10,{fhSemester1: "2020/4/10", fhSemester2: "2020/7/30", lateSemester1: "2020/9/14", lateSemester2: "2021/1/22"})
        self.where(calendar_id:cal_id).each do |period|
            ins = {fhSemester1: period.fh_semester_f.strftime("%Y/%m/%d"), fhSemester2: period.fh_semester_s.strftime("%Y/%m/%d"), lateSemester1:period.late_semester_f.strftime("%Y/%m/%d"), lateSemester2:period.late_semester_s.strftime("%Y/%m/%d")}
            result[period.grade - 1] = ins
        end
        
        return result
    end
end
