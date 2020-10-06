class Api::V1::TransferScheduleController < ApplicationController
  before_action :userSignedin?, :only => [:create] #セッションの確認
  before_action :calendarOwn?, :only => [:create] #カレンダーの所有者か確認

  def create
    @calendar.transfer_schedules.uniq_create(
      :before => params[:beforeDate], 
      :after => params[:afterDate]
    )
    if @calendar.save
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => '授業変更を作成しました',
      })
    else
      errorJson = RenderErrorJson.new()
      render status: 400, json: errorJson.createError(status: 400, code: 'AE_0025', api_version: 'v1')
    end
  end
end
