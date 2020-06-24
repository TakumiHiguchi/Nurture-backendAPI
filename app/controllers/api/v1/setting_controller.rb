class Api::V1::SettingController < ApplicationController
    
    def setGrade
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession && params[:grade].nil?
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
        
    end
    
end
