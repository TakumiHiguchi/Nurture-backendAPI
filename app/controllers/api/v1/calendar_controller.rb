class Api::V1::CalendarController < ApplicationController
  before_action :userSignedin?, :only => [:index,:create,:update,:destroy] #セッションの確認
  before_action :calendarOwn?, :only => [:update,:destroy] #カレンダーの所有者か確認
  def index
    #ユーザーのカレンダー取得
    result = @user.calendars.include_all_tables.map{ |calendar| calendar.create_calendar_hash(@user) }
    render :json => JSON.pretty_generate({
      :status => 'SUCCESS',
      :api_version => 'v1',
      :calendars => result
    })
  end

  def create    
    errorJson = RenderErrorJson.new()
    @user.calendars.build(create_calendar_params)

    if @user.save
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => 'カレンダーを作成しました。'
      })
    else
      render json: errorJson.createError(code:'AE_0010',api_version:'v1')
    end
  end

  def update
    errorJson = RenderErrorJson.new()
    if @calendar.update(update_calendar_params)
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "カレンダーを変更しました。"
      })
    else
      render json: errorJson.createError(code:'AE_0011',api_version:'v1')
    end
  end

  def destroy
    errorJson = RenderErrorJson.new()
    if @calendar.destroy
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "カレンダーを削除しました。"
      })
    else
      render json: errorJson.createError(code:'AE_0012',api_version:'v1')
    end
  end

  private
  def create_calendar_params
    base_worker = BaseWorker.new
    return({
      :key => base_worker.get_key,
      :name => params[:name],
      :description => params[:description],
      :shareBool => params[:shareBool],
      :cloneBool => params[:cloneBool],
      :author_id => @user.id
    })
  end

  def update_calendar_params
    return({
      :name => params[:name],
      :description => params[:description],
      :color => params[:color],
      :shareBool => params[:shareBool],
      :cloneBool => params[:cloneBool]
    })
  end
end
