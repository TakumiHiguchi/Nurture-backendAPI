class Api::V1::CalendarShareController < ApplicationController
    def search
        result = []
        if params[:type] == "search" then
            calendar = Calendar.where(shareBool:true)
        else
            calendar = Calendar.where(shareBool:true)
        end
        calendar.each do |cal|

            #Taskを取得してカウントする
            tasks = Task.where(calendar_id:cal.id).count
            #Examを取得してカウントする
            exams = Exam.where(calendar_id:cal.id).count
            #授業変更を取得してカウントする
            cs0 = ChangeSchedule.where(calendar_id:cal.id).count
            #スケジュールを取得してカウントする
            schedules = CalendarScheduleRelation.where(calendar_id:cal.id).count

            #作成者
            authorData = User.joins(:user_details).select("users.*, user_details.*").find_by("users.id = ?", cal.author_id)

            result.push(
                id: cal.id,
                name: cal.name,
                description: cal.description,
                key: cal.key,
                shareBool: cal.shareBool,
                cloneBool: cal.cloneBool,
                author_id: cal.author_id,
                author_name: authorData.name,
                color: cal.color,
                taskCount: tasks,
                examCount: exams,
                change_schedulesCount:cs0,
                scheduleCount: schedules
            )
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
