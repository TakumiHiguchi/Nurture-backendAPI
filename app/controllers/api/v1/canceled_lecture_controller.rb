class Api::V1::CanceledLectureController < ApplicationController
  before_action :userSignedin?, :only => [:create] #セッションの確認
  before_action :calendarOwn?, :only => [:create] #カレンダーの所有者か確認
  def create
    errorJson = RenderErrorJson.new()
    @calendar.canceled_lectures.build(canceld_lecture_params)
    if @calendar.save then
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "休講の予定を作成しました",
      })
    else
      render json: errorJson.createError(code:'AE_0020',api_version:'v1')
    end
  end

  private
  def canceld_lecture_params
    return({
      :grade => params[:grade], 
      :clDate => params[:date], 
      :position => params[:position]
    })
  end
end
