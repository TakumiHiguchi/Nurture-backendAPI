class Api::V1::TransferScheduleController < ApplicationController
    before_action :userSignedin?, :only => [:create,:destroy] #セッションの確認
    before_action :calendarOwn?, :only => [:create,:destroy] #カレンダーの所有者か確認

    def create
        if @userSession && @calendarOwn
            #sessionが有効だったら授業の移動を作る
            result,mes = TransferSchedule.check_and_create(params[:calendarId], params[:beforeDate], params[:afterDate])
        else
            result = false
            mes = "セッションが無効です"
        end
        
        if result
            render :json => JSON.pretty_generate({
                                              :status => 'SUCCESS',
                                              :api_version => 'v1',
                                              :mes => mes,
            })
        else
            render :json => JSON.pretty_generate({
                                              :status => 'ERROR',
                                              :api_version => 'v1',
                                              :mes => mes
            })
        end
    end
    def destroy
        
    end
end
