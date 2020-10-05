class Api::V1::ScheduleController < ApplicationController
    before_action :userSignedin?, :only => [:create] #セッションの確認
    
    def index
      schedules = Schedule.all.order('id DESC').searchAPI("position",params[:p]).searchAPI("fr",params[:q]).first(50)
      result = [];
      schedules.each do |pas|
          result.push(
                      :id => pas.id,
                      :title => pas.title,
                      :CoNum => pas.CoNum,
                      :teacher => pas.teacher,
                      :semester => pas.semester,
                      :position => pas.position,
                      :grade => pas.grade,
                      :status => pas.status
                      )
      end
      
      
      render :json => JSON.pretty_generate({
                                        :status => 'SUCCESS',
                                        :api_version => 'v1',
                                        :data_count => result.length,
                                        :schedules => result
                                        
                                        })
                
    end
    def create
      check = Schedule.where(:title => params[:title], :teacher => params[:teacher], :semester => params[:semester], :position => params[:position], :grade => params[:grade])
      if check.length <= 0
        result = Schedule.create(
          :title => params[:title],
          :CoNum => params[:number],
          :teacher => params[:teacher],
          :semester => params[:semester],
          :position => params[:position],
          :grade => params[:grade],
          :status => params[:status]
        )
        result = result.save
        if result
          mes = "授業を作成しました"
        else
          mes = "授業の作成に失敗しました。"
        end
      else
        if check.length > 0
          result = nil
          mes = "同じ授業が存在するため失敗しました"
        else
          result = nil
          mes = "セッションが無効です"
        end
      end
      if result
        render :json => JSON.pretty_generate({
          :status => 'SUCCESS',
          :api_version => 'v1',
          :mes => mes,
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
