class Api::V1::TaskController < ApplicationController
    
    before_action :userSignedin?, only: [:index,:create,:update] #セッションの確認
    
    def index
        if @userSession
            #sessionが有効だったらユーザーのタスクを返す
            task = UserTask.where(user_id:@user.id)
            result = {}
            
            task.each do |t|
                #年:月:日をkeyに持つhashを生成し、そこにタスク内容をpushしていく
                #年の作成
                reIns = result[t.taskDate.strftime("%Y").to_i]
                if reIns.nil?
                    result[t.taskDate.strftime("%Y").to_i] ={}
                    reIns = result[t.taskDate.strftime("%Y").to_i]
                end
                #月の作成
                reIns1 = reIns[t.taskDate.strftime("%m").to_i]
                if reIns1.nil?
                    result[t.taskDate.strftime("%Y").to_i][t.taskDate.strftime("%m").to_i] = {}
                    reIns1 = result[t.taskDate.strftime("%Y").to_i][t.taskDate.strftime("%m").to_i]
                end
                #日の作成
                reIns2 = reIns1[t.taskDate.strftime("%d").to_i]
                if reIns2.nil?
                    result[t.taskDate.strftime("%Y").to_i][t.taskDate.strftime("%m").to_i][t.taskDate.strftime("%d").to_i] = []
                    reIns2 = result[t.taskDate.strftime("%Y").to_i][t.taskDate.strftime("%m").to_i][t.taskDate.strftime("%d").to_i]
                end

                
                ins = {
                    id:t.id,
                    title:t.title,
                    content:t.content,
                    date:t.taskDate,
                    position:t.position
                }
                reIns2.push(ins)
                result[t.taskDate.strftime("%Y").to_i][t.taskDate.strftime("%m").to_i][t.taskDate.strftime("%d").to_i] = reIns2
            end
            if result
                mes = "タスクを取得しました"
            else
                mes = "タスクの取得に失敗しました。"
            end
        else
            result = nil
            mes = "セッションが無効です"
        end
        
        if result
            render json: JSON.pretty_generate({
                                              status:'SUCCESS',
                                              api_version: 'v1',
                                              mes: mes,
                                              tasks:result
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes: mes
            })
        end
        
        
    end
    def create
        if @userSession
            #sessionが有効だったらタスクを作る
            result = UserTask.create(user_id:@user.id, title: params[:title], content: params[:content], taskDate:params[:taskdate], position:params[:position])
            result = result.save
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
