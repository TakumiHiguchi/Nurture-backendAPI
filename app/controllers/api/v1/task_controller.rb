class Api::V1::TaskController < ApplicationController
    
    def index
    end
    def create
        #sessionの確認
        user = User.find_by(key: params[:key],session: params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        
        if userSession
            #sessionが有効だったらユーザーのスケジュールを返す
            result = UserTask.create(user_id:user.id, title: params[:title], content: params[:content], taskDate:params[:taskdate], position:params[:position])
            if result
                mes = "タスクを作成しました"
            else
                mes = "タスクの作成に失敗しました。"
            end
        else
            result = false
            mes = "セッションが無効です"
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
    end
end
