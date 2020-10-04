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
    result = @user.calendars.build(create_calendar_params)

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
        if @userSession && @calendarOwn
            
            if params[:name] == "" 
                calBoolean = false
                mes = "名前は最低1文字以上でなくてはなりません"
            else
                calendar = Calendar.find_by(:id => params[:calendarId])
                calBoolean = calendar.update(
                    :name => params[:name],
                    :description => params[:description],
                    :color => params[:color],
                    :shareBool => params[:shareBool],
                    :cloneBool => params[:cloneBool]
                )
            end
        else
            calBoolean = false
            mes = "アクセス権限がありません。"
        end
        if calBoolean
            render :json => JSON.pretty_generate({
                                              :status => 'SUCCESS',
                                              :api_version => 'v1',
                                              :mes => "カレンダーを変更しました。"
            })
        else
            render :json => JSON.pretty_generate({
                                              :status => 'ERROR',
                                              :api_version => 'v1',
                                              :mes => mes
            })
        end
    end
    def destroy
        check = UserCalendarRelation.where(:user_id => @user.id).count
        if @userSession && check > 1
            if !@calendarOwn
                ens = UserCalendarRelation.find_by(:calendar_id => params[:calendarId], :user_id => @user.id)
                ens.destroy
                render :json => JSON.pretty_generate({
                                                    :status => 'SUCCESS',
                                                    :api_version => 'v1',
                                                    :mes => "カレンダーを削除しました。"
                                                    })
            else
                ins = Calendar.find_by(:id => params[:calendarId])
                ens = UserCalendarRelation.find_by(:calendar_id => params[:calendarId], :user_id => @user.id)
                if ins.destroy && ens.destroy
                    render :json => JSON.pretty_generate({
                                                        :status => 'SUCCESS',
                                                        :api_version => 'v1',
                                                        :mes => "カレンダーを削除しました。"
                                                        })
                else
                    render :json => JSON.pretty_generate({
                                                        :status => 'Error',
                                                        :api_version => 'v1',
                                                        :mes => 'カレンダーの削除に失敗しました。'
                    
                                                        })
                end
            end
        else
            mes = 'セッション切れです'
            if check <= 1
                mes = "最低でも一個のカレンダーがなければなりません。"
            end
            render :json => JSON.pretty_generate({
                                                  :status => 'Error',
                                                  :api_version => 'v1',
                                                  :mes => mes
              
                                                  })
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
end
