class Api::V1::TaskController < ApplicationController
    
    before_action :userSignedin?, only: [:index,:create,:update,:destroy] #セッションの確認
    before_action :calendarOwn?, only: [:create] #カレンダーの所有者か確認
    
    def index
        if @userSession
        end
        
        
    end
    def create
        if @userSession && @calendarOwn
            #sessionが有効だったらタスクを作る
            result = Task.create(calendar_id:params[:calendarId], title: params[:title], content: params[:content], taskDate:params[:taskdate], position:params[:position])
            result = result.save
            if result
                mes = "タスクを作成しました"
            else
                mes = "タスクの作成に失敗しました。"
            end
        else
            result = false
            mes = "セッションが無効です"
            mes = "カレンダーの所有者ではありません" if !@calendarOwn
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes,
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
    end
    def update
        if @userSession
            #sessionが有効だったらタスクを作る
            ins = UserTask.find_by(user_id:@user.id,id:params[:task_id])
            ins = ins.update(user_id:@user.id, title: params[:title], content: params[:content], taskDate:params[:taskdate], position:params[:position],complete:params[:complete])
            if ins
                render json: JSON.pretty_generate({
                                                  status:'SUCCESS',
                                                  api_version: 'v1',
                                                  mes:"タスクを更新しました。"
                                                  })
            else
                render json: JSON.pretty_generate({
                                                    status:'Error',
                                                    api_version: 'v1',
                                                    mes: 'タスクの更新に失敗しました。'
                                                    })
            end
        end
    end
    def destroy
        if @userSession
        #sessionが有効だったらタスクを作る
          ins = UserTask.find_by(user_id:@user.id,id:params[:task_id])
          if ins.destroy
              render json: JSON.pretty_generate({
                                                status:'SUCCESS',
                                                api_version: 'v1',
                                                mes:"タスクを削除しました。"
                                                })
          else
              render json: JSON.pretty_generate({
                                                  status:'Error',
                                                  api_version: 'v1',
                                                  mes: 'タスクの削除に失敗しました。'
              
                                                  })
          end
        end
    end
end
