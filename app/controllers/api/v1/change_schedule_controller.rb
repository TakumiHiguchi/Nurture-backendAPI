class Api::V1::ChangeScheduleController < ApplicationController
    before_action :userSignedin?, :only => [:index,:create,:update,:destroy] #セッションの確認
    before_action :calendarOwn?, :only => [:create, :update, :destroy] #カレンダーの所有者か確認
    
    def index
        if @userSession
        end
    end

    def create
            #sessionが有効だったら授業の移動を作る
            result,mes = ChangeSchedule.check_and_create(params[:calendarId], params[:selectSchedule_id], params[:beforeDate], params[:afterDate], params[:position])

        
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

    def update
    end
    def destroy
        if @userSession && @calendarOwn
          ins = ChangeSchedule.find_by(:calendar_id => params[:calendarId], :id => params[:change_schedule_id])
          if ins.destroy
              render :json => JSON.pretty_generate({
                                                :status => 'SUCCESS',
                                                :api_version => 'v1',
                                                :mes => "授業変更を削除しました。"
                                                })
          else
              render :json => JSON.pretty_generate({
                                                  :status => 'Error',
                                                  :api_version => 'v1',
                                                  :mes => '授業変更の削除に失敗しました。'
              
                                                  })
          end
        end
    end
end
