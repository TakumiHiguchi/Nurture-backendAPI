class Api::V1::CalendarController < ApplicationController
    before_action :userSignedin?, only: [:index,:create,:update,:destroy] #セッションの確認
    before_action :calendarOwn?, only: [:update,:destroy] #カレンダーの所有者か確認
    def index
        if @userSession
            result = []
            #ユーザーのカレンダー取得
            calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", @user.id)
            calendar.each do |cal|

                #Taskを取得して格納する
                tasks = Task.createDatekeyArrayOfTask(cal.id)
                #Examを取得して格納する
                exams = Exam.createDatekeyArrayOfExam(cal.id)
                #授業変更を取得して格納する
                cs0,cs1 = ChangeSchedule.createDatekeyArrayOfChangeSchedule(cal.id)
                #学期の期間を取得して格納する
                sp = SemesterPeriod.loadUserPeriod(cal.id)
                #スケジュール
                schedules = Schedule.loadSchedule(cal.id)



                #振替
                cL1,cL2 = TransferSchedule.loadCL(cal.id)

                #作成者
                authorData = User.joins(:user_details).select("users.*, user_details.*").find_by("users.id = ?", cal.author_id)

                result.push(
                    id: cal.id,
                    user_id:@user.id,
                    name: cal.name,
                    description: cal.description,
                    key: cal.key,
                    shareBool: cal.shareBool,
                    cloneBool: cal.cloneBool,
                    author_id: cal.author_id,
                    author_name: authorData.name,
                    color: cal.color,
                    tasks: tasks,
                    exams: exams,
                    change_schedules_after:cs0,
                    change_schedules_before:cs1,
                    semesterPeriod: sp,
                    schedules: schedules,
                    transfer_schedule_after: cL1,
                    transfer_schedule_before: cL2
                )
            end
        end

        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              calendars:result
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
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
            key = (0...20).map { o[rand(o.length)] }.join
            result = Calendar.create(
                key:key,
                name: params[:name],
                description: params[:description],
                shareBool: params[:shareBool],
                cloneBool: params[:cloneBool],
                author_id: @user.id
            )
            if result then UserCalendarRelation.create(user_id:@user.id, calendar_id:result.id) end
        else
            calBoolean = false
            mes = "セッション切れです"
        end
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: "カレンダーを作成しました。"
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
        if @userSession && @calendarOwn
            
            if params[:name] == "" 
                calBoolean = false
                mes = "名前は最低1文字以上でなくてはなりません"
            else
                calendar = Calendar.find_by(id:params[:calendarId])
                calBoolean = calendar.update(
                    name: params[:name],
                    description: params[:description],
                    color: params[:color],
                    shareBool: params[:shareBool],
                    cloneBool: params[:cloneBool]
                )
            end
        else
            calBoolean = false
            mes = "アクセス権限がありません。"
        end
        if calBoolean
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: "カレンダーを変更しました。"
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end
    def destroy
        check = UserCalendarRelation.where(user_id:@user.id).count
        if @userSession && check > 1
            if !@calendarOwn
                ens = UserCalendarRelation.find_by(calendar_id:params[:calendarId], user_id:@user.id)
                ens.destroy
                render json: JSON.pretty_generate({
                                                    status:'SUCCESS',
                                                    api_version: 'v1',
                                                    mes:"カレンダーを削除しました。"
                                                    })
            else
                ins = Calendar.find_by(id:params[:calendarId])
                ens = UserCalendarRelation.find_by(calendar_id:params[:calendarId], user_id:@user.id)
                if ins.destroy && ens.destroy
                    render json: JSON.pretty_generate({
                                                        status:'SUCCESS',
                                                        api_version: 'v1',
                                                        mes:"カレンダーを削除しました。"
                                                        })
                else
                    render json: JSON.pretty_generate({
                                                        status:'Error',
                                                        api_version: 'v1',
                                                        mes: 'カレンダーの削除に失敗しました。'
                    
                                                        })
                end
            end
        else
            mes = 'セッション切れです'
            if check <= 1
                mes = "最低でも一個のカレンダーがなければなりません。"
            end
            render json: JSON.pretty_generate({
                                                  status:'Error',
                                                  api_version: 'v1',
                                                  mes: mes
              
                                                  })
        end
    end
end
