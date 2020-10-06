class Api::V1::UserScheduleController < ApplicationController
  before_action :userSignedin?, :only => [:destroy] #セッションの確認
  before_action :calendarOwn?, :only => [:destroy] #カレンダーの所有者か確認
  
  def destroy
    csr = CalendarScheduleRelation.find_by(:calendar_id => params[:calendarId],:schedule_id => params[:schedule_id],:reges_grade => params[:grade])
    if csr.destroy
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "スケジュールを削除しました。"
      })
    else
      render status: 400, json: errorJson.createError(status: 400, code: 'AE_0016', api_version: 'v1')
    end
  end
end
