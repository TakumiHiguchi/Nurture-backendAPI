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
        if @userSession
            ins = Calendar.find_by(:id => params[:calendarId])
            if ins.cloneBool && ins.shareBool
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
                key = (0...20).map { o[rand(o.length)] }.join
                result = Calendar.create(
                    :key => key,
                    :name => ins.name,
                    :description => ins.description,
                    :shareBool => ins.shareBool,
                    :cloneBool => ins.cloneBool,
                    :author_id => @user.id
                )
                if result 
                    UserCalendarRelation.create(:user_id => @user.id, :calendar_id => result.id) 
                    Task.clone(ins.id, result.id)
                    Exam.clone(ins.id, result.id)
                    CalendarScheduleRelation.clone(ins.id, result.id)
                    ChangeSchedule.clone(ins.id, result.id)
                    SemesterPeriod.clone(ins.id, result.id)
                    TransferSchedule.clone(ins.id, result.id)
                end
            else
                result = false
                mes = "クローンが許可されていません。"
            end
            if result
                render :json => JSON.pretty_generate({
                                                  :status => 'SUCCESS',
                                                  :api_version => 'v1',
                                                  :mes => "カレンダーをコピーしました"
                })
            else
                render :json => JSON.pretty_generate({
                                                  :status => 'ERROR',
                                                  :api_version => 'v1',
                                                  :mes => mes
                })
            end
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
