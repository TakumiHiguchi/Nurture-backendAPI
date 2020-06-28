class Api::V1::SettingController < ApplicationController
    
    def setGrade
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession && !params[:grade].nil?
            user.grade = params[:grade]
            result = user.save
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
            sP = SemesterPeriod.find_by(user_id: user.id,grade:params[:grade])
            if !sP
                result = SemesterPeriod.create(user_id:user.id, grade:params[:grade], fh_semester_f:params[:date1], fh_semester_s:params[:date2], late_semester_f:params[:date3], late_semester_s:params[:date4])
                mes = "期間を新しく作りました。"
            else
                result = sP.update(user_id:user.id, grade:params[:grade], fh_semester_f:params[:date1], fh_semester_s:params[:date2], late_semester_f:params[:date3], late_semester_s:params[:date4])
                mes = "期間を更新しました。"
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
end
