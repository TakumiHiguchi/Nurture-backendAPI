class Api::V1::UserController < ApplicationController
  require 'digest/sha2' #ハッシュ
  require 'date'
  before_action :userSignedin?, :only => [:setUserSchedule, :update] #セッションの確認
  before_action :calendarOwn?, :only => [:setUserSchedule] #カレンダーの所有者か確認

  def setUserSchedule
    schedule = Schedule.find_by(
      :title => params[:title],
      :teacher => params[:teacher],
      :semester => params[:semester],
      :position => params[:position],
      :grade => params[:grade]
    )
    result = CalendarScheduleRelation.uniq_create(:schedule => schedule, :calendar_id => params[:calendarId], :reges_grade => params[:user_grade].to_i)
    if result
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "スケジュールを登録しました"
      })
    else
      errorJson = RenderErrorJson.new()
      render json: errorJson.createError(code:'AE_0037',api_version:'v1')
    end
  end
  
  def loadUserDetail
      #sessionの確認
      user = User.find_by(:key => params[:key],:session => params[:session])
      userSession = user.maxAge.to_i > Time.now.to_i if user
      
      if userSession
          #sessionが有効だったらユーザーのスケジュールを返す
          userDetail = UserDetail.new
          result_schedule, mes = userDetail.setSchedule(user.id)
          
          
      else
          result_schedule = false
          mes = "セッションが無効です"
      end
      
      if result_schedule
          render :json => JSON.pretty_generate({
                                            :status => 'SUCCESS',
                                            :api_version => 'v1',
                                            :mes => mes,
                                            :schedules => result_schedule
          })
      else
          render :json => JSON.pretty_generate({
                                            :status => 'ERROR',
                                            :api_version => 'v1',
                                            :mes => mes
          })
      end
  end
  def update
      if @userSession
          userDetail = UserDetail.find_by(:user_id => @user.id)
          result = userDetail.update(:name => params[:name])
          if result
              render :json => JSON.pretty_generate({
                                                :status => 'SUCCESS',
                                                :api_version => 'v1',
                                                :mes => "ユーザーを更新しました"
              })
          else
              render :json => JSON.pretty_generate({
                                                :status => 'ERROR',
                                                :api_version => 'v1',
                                                :mes => "ユーザーの更新に失敗しました"
              })
          end
      end
  end
end
