class Api::V1::ScheduleController < ApplicationController
    before_action :userSignedin?, only: [:create,:update,:destroy] #セッションの確認
    
  def index
      schedules = Schedule.all.order('id DESC').searchAPI("position",params[:p]).searchAPI("fr",params[:q]).first(50)
      result = [];
      schedules.each do |pas|
          result.push(
                      id:pas.id,
                      title:pas.title,
                      CoNum:pas.CoNum,
                      teacher:pas.teacher,
                      semester:pas.semester,
                      position:pas.position,
                      grade:pas.grade,
                      status:pas.status
                      )
      end
      
      
      render json: JSON.pretty_generate({
                                        status:'SUCESS',
                                        api_version: 'v1',
                                        data_count:result.length,
                                        schedules: result
                                        
                                        })
                
  end

  def show
  end

  def create
  end

  def update
  end
  
    def destroy

      
  end
end
