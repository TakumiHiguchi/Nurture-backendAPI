class Api::V1::CalendarController < ApplicationController
    before_action :userSignedin?, only: [:index] #セッションの確認
    def index
        if @userSession
            result = []
            calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", @user.id)
            calendar.each do |cal|
                #booleanを加工する
                cal.shareBool == 0 ? cal.shareBool = false : cal.shareBool = true
                cal.cloneBool == 0 ? cal.cloneBool = false : cal.cloneBool = true

                #Taskを取得して格納する
                tasks = Task.createDatekeyArrayOfTask(cal.id)
                #Examを取得して格納する
                exams = Exam.createDatekeyArrayOfExam(cal.id)
                #授業変更を取得して格納する
                cs0,cs1 = ChangeSchedule.createDatekeyArrayOfChangeSchedule(cal.id)
                #学期の期間を取得して格納する
                sp = SemesterPeriod.loadUserPeriod(cal.id)

                result.push(
                    id: cal.id,
                    name: cal.name,
                    description: cal.description,
                    key: cal.key,
                    shareBool: cal.shareBool,
                    cloneBool: cal.cloneBool,
                    author_id: cal.author_id,
                    tasks: tasks,
                    exams: exams,
                    change_schedules_after:cs0,
                    change_schedules_before:cs1,
                    semesterPeriod: sp
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
end
