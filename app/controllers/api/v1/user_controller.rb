class Api::V1::UserController < ApplicationController
    require 'digest/sha2' #ハッシュ
    require 'date'
    
    
    
    def setUserSchedule
        userSession = false
        schedule = Schedule.find_by(title: params[:title],teacher: params[:teacher], semester: params[:semester], position: params[:position], grade:params[:grade])
        
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        #scheduleがなかった場合作る
        schedule = Schedule.create(title: params[:title],teacher: params[:teacher], semester: params[:semester], position: params[:position], grade:params[:grade]) if schedule.nil?
        
        if userSession
            #Relationを作る
            relation,result,mes = UserScheduleRelation.exists_and_create(user.id, schedule, params[:user_grade].to_i)
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
    
    def loadUserDetail
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession
            #sessionが有効だったらユーザーのスケジュールを返す
            userDetail = UserDetail.new
            result_schedule, mes = userDetail.setSchedule(user.id)
            
            
        else
            result_schedule = false
            mes = "セッションが無効です"
        end
        
        if result_schedule
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes,
                                              schedules: result_schedule
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
