class Api::V1::ScheduleController < ApplicationController
  before_action :userSignedin?, :only => [:create] #セッションの確認
    
  def index
    result = Schedule.searchAPI("position",params[:p]).searchAPI("fr",params[:q]).first(50).map{ |schedule| schedule.create_schedule_hash }
    render :json => JSON.pretty_generate({
      :status => 'SUCCESS',
      :api_version => 'v1',
      :data_count => result.length,
      :schedules => result
    })     
  end

  def create
    errorJson = RenderErrorJson.new()
    schedule = Schedule.create(create_params)
    if schedule.save
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => '授業を作成しました',
      })
    else
      render json: errorJson.createError(code:'AE_0035',api_version:'v1')
    end
  end

  private
  def create_params
    return({
      :title => params[:title],
      :CoNum => params[:number],
      :teacher => params[:teacher],
      :semester => params[:semester],
      :position => params[:position],
      :grade => params[:grade],
      :status => params[:status]
    })
  end
end
