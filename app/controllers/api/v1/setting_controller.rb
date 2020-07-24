class Api::V1::SettingController < ApplicationController
    
    def setGrade
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession && !params[:grade].nil?
            userDetail = UserDetail.find_by(user_id:user.id)
            userDetail.grade = params[:grade]
            result = userDetail.save
            mes = "学年を更新しました。"
        else
            result = false
            mes = "セッションが無効です"
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end
    
    def setSemesterDate
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession && Time.parse(params[:date1]) < Time.parse(params[:date2]) && Time.parse(params[:date2]) < Time.parse(params[:date3]) && Time.parse(params[:date3]) < Time.parse(params[:date4])
            if calendarOwn(user.id ,params[:calendarId])
                sP = SemesterPeriod.find_by(calendar_id: params[:calendarId], grade:params[:grade])
                if !sP
                    result = SemesterPeriod.create!(calendar_id: params[:calendarId], grade:params[:grade], fh_semester_f:params[:date1], fh_semester_s:params[:date2], late_semester_f:params[:date3], late_semester_s:params[:date4])
                    mes = "期間を新しく作りました。"
                else
                    result = sP.update(calendar_id: params[:calendarId], grade:params[:grade], fh_semester_f:params[:date1], fh_semester_s:params[:date2], late_semester_f:params[:date3], late_semester_s:params[:date4])
                    mes = "期間を更新しました。"
                end
            else
                result = false
                mes = "カレンダーを所有していません"
            end
            
        else
            result = false
            mes = "セッションが無効です"
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end
    def calendarOwn(user_id ,cal_id)
        calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", user_id).where("calendars.id = ?", cal_id).where("calendars.author_id = ?", user_id)
        return calendar.length > 0
    end
end
