class Api::V1::CalendarShareController < ApplicationController
  before_action :userSignedin?, :only => [:clone, :search, :follow, :destroy_follow] #セッションの確認
  def search
    calendar = Calendar.search(params[:q]).share_only.not_author(@user)
    result = calendar.include_all_tables.map{ |calendar| calendar.create_calendar_hash(@user) }
    render :json => JSON.pretty_generate({
      :status => 'SUCCESS',
      :api_version => 'v1',
      :calendars => result
    })
  end

  def clone
    errorJson = RenderErrorJson.new()
    @calendar = Calendar.share_only.clone_only.find(params[:calendarId])
    if @calendar.present?
      @calendar.clone(@user)
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "カレンダーをコピーしました"
      })
    else
      render status: 400, json: errorJson.createError(status: 400, code: 'AE_0013', api_version: 'v1')
    end
  end

  def follow
    errorJson = RenderErrorJson.new()
    @calendar = Calendar.share_only.find(params[:calendarId])
    if @calendar.present?
      UserCalendarRelation.create(:user_id => @user.id, :calendar_id => params[:calendarId])
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "カレンダーをフォローしました"
      })
    else
      render status: 400, json: errorJson.createError(status: 400, code: 'AE_0014',api_version: 'v1')
    end
  end

  def destroy_follow
    errorJson = RenderErrorJson.new()
    relation = UserCalendarRelation.find_by(:user_id => @user.id, :calendar_id => params[:calendarId])
    if relation.present?
      relation.delete
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "カレンダーをアンフォローしました"
      })
    else
      render status: 400, json: errorJson.createError(status: 400, code: 'AE_0015', api_version: 'v1')
    end
  end

end
