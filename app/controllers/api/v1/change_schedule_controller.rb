class Api::V1::ChangeScheduleController < ApplicationController
    before_action :userSignedin?, only: [:index,:create,:update] #セッションの確認
    
    def index
        if @userSession
            #sessionが有効だったらユーザーの試験を返す
            changeSchedule = ChangeSchedule.joins(:schedule).select("change_schedules.* ,schedules.* ,change_schedules.position AS change_schedules_id").where(user_id:@user.id)
            result = {}
            result1 = {}
            
            changeSchedule.each do |t|
                #年:月:日をkeyに持つhashを生成し、そこに試験内容をpushしていく
                dkArray = DateKeysArray.new
                result = dkArray.createDateKeysArray(result, t.afterDate)
                dkArray1 = DateKeysArray.new
                result1 = dkArray1.createDateKeysArray(result1, t.beforeDate)
                ins = {
                    id:t.id,
                    title:t.title,
                    CoNum:t.CoNum,
                    teacher:t.teacher,
                    semester:t.semester,
                    after_position:t.change_schedules_id,
                    grade:t.grade,
                    status:t.status,
                    afterDate:t.afterDate
                }
                result[t.afterDate.strftime("%Y").to_i][t.afterDate.strftime("%m").to_i][t.afterDate.strftime("%d").to_i].push(ins)
                ins = {
                    id:t.id,
                    title:t.title,
                    CoNum:t.CoNum,
                    teacher:t.teacher,
                    semester:t.semester,
                    before_position:t.position,
                    after_position:t.change_schedules_id,
                    afterDate:t.afterDate,
                    grade:t.grade,
                    status:t.status,
                    beforeDate:t.beforeDate
                }
                result1[t.beforeDate.strftime("%Y").to_i][t.beforeDate.strftime("%m").to_i][t.beforeDate.strftime("%d").to_i].push(ins)
            end
            if result
                mes = "授業の変更を取得しました"
            else
                mes = "授業の変更の取得に失敗しました。"
            end
        else
            result = nil
            mes = "セッションが無効です"
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes,
                                              change_schedules_after:result,
                                              change_schedules_before:result1
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end

    def create
        if @userSession
            #sessionが有効だったら授業の移動を作る
            result,mes = ChangeSchedule.check_and_create(@user.id, params[:selectSchedule_id], params[:beforeDate], params[:afterDate], params[:position])
        else
            result = false
            mes = "セッションが無効です"
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes,
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end

    def update
    end
end
