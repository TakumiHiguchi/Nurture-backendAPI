class Api::V1::UserScheduleController < ApplicationController
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
        p "a"
        p params
        ins = UserScheduleRelation.find_by(user_id:@user.id,schedule_id:params[:schedule_id],reges_grade:params[:grade])
        if ins.destroy
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1'
          
                                              })
        else
            render json: JSON.pretty_generate({
                                                status:'Error',
                                                api_version: 'v1',
                                                mes: 'スケジュールの削除に失敗しました。'
            
                                                })
        end
      
  end
end
