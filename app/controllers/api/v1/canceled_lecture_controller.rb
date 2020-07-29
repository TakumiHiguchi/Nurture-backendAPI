class Api::V1::CanceledLectureController < ApplicationController
    before_action :userSignedin?, only: [:create] #セッションの確認
    before_action :calendarOwn?, only: [:create] #カレンダーの所有者か確認
    def create
        if @userSession && @calendarOwn
            #sessionが有効だったら作る
            result = CanceledLecture.create(
                calendar_id:params[:calendarId], 
                grade: params[:grade], 
                clDate:params[:date], 
                position:params[:position]
            )
            result = result.save
            if result
                mes = "休講の予定を作成しました"
            else
                mes = "休講の予定の作成に失敗しました。"
            end
        else
            result = false
            mes = "セッションが無効です"
            mes = "カレンダーの所有者ではありません" if !@calendarOwn
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
end
