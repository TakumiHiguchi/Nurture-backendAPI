class Api::V1::CalendarShareController < ApplicationController
  before_action :userSignedin?, :only => [:clone, :search, :follow] #セッションの確認
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
      render json: errorJson.createError(code:'AE_0013',api_version:'v1')
    end
  end
    def follow
        if @userSession
            ins = Calendar.find_by(:id => params[:calendarId])
            if ins.shareBool
                UserCalendarRelation.create(:user_id => @user.id, :calendar_id => params[:calendarId])
                render :json => JSON.pretty_generate({
                                                  :status => 'SUCCESS',
                                                  :api_version => 'v1',
                                                  :mes => "カレンダーをフォローしました"
                })
            else
                render :json => JSON.pretty_generate({
                                                  :status => 'ERROR',
                                                  :api_version => 'v1',
                                                  :mes => "フォローが許可されていません。"
                })
            end
        end
    end
    # follow deleteするメソッドを作る
    #フロントも変更

end
