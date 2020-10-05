class Api::V1::ChangeScheduleController < ApplicationController
  before_action :userSignedin?, :only => [:create,:destroy] #セッションの確認
  before_action :calendarOwn?, :only => [:create, :destroy] #カレンダーの所有者か確認

  def create
    errorJson = RenderErrorJson.new()
    result = @calendar.change_schedules.uniq_create(
      :schedule_id => params[:selectSchedule_id],
      :before => params[:beforeDate],
      :after => params[:afterDate],
      :position => params[:position]
    )

    if @calendar.save && result.present?
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => '授業の移動を作成しました',
      })
    else
      render json: errorJson.createError(code:'AE_0025',api_version:'v1')
    end
  end

  def destroy
    chenge_schedule = @calendar.change_schedules.find(params[:change_schedule_id])
    if chenge_schedule.destroy
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "授業変更を削除しました。"
      })
    else
      render json: errorJson.createError(code:'AE_0026',api_version:'v1')
    end
  end
end
