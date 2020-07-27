class Api::V1::UserScheduleController < ApplicationController
  before_action :userSignedin?, only: [:destroy] #セッションの確認
  before_action :calendarOwn?, only: [:destroy] #カレンダーの所有者か確認
    
  def index
                
  end

  def show
  end

  def create
  end

  def update
  end
  
    def destroy
      if @userSession && @calendarOwn
        ins = CalendarScheduleRelation.find_by(calendar_id:params[:calendarId],schedule_id:params[:schedule_id],reges_grade:params[:grade])
        if ins.destroy
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes:"スケジュールを削除しました。"
                                              })
        else
            render json: JSON.pretty_generate({
                                                status:'Error',
                                                api_version: 'v1',
                                                mes: 'スケジュールの削除に失敗しました。'
            
                                                })
        end
      end
  end
end
