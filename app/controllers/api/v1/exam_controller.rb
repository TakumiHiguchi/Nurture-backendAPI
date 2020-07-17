class Api::V1::ExamController < ApplicationController
    before_action :userSignedin?, only: [:index,:create,:update] #セッションの確認
    
    def index
        if @userSession
            #sessionが有効だったらユーザーの試験を返す
            task = Exam.where(user_id:@user.id)
            result = {}
            
            task.each do |t|
                #年:月:日をkeyに持つhashを生成し、そこに試験内容をpushしていく
                #年の作成
                reIns = result[t.examDate.strftime("%Y").to_i]
                if reIns.nil?
                    result[t.examDate.strftime("%Y").to_i] ={}
                    reIns = result[t.examDate.strftime("%Y").to_i]
                end
                #月の作成
                reIns1 = reIns[t.examDate.strftime("%m").to_i]
                if reIns1.nil?
                    result[t.examDate.strftime("%Y").to_i][t.examDate.strftime("%m").to_i] = {}
                    reIns1 = result[t.examDate.strftime("%Y").to_i][t.examDate.strftime("%m").to_i]
                end
                #日の作成
                reIns2 = reIns1[t.examDate.strftime("%d").to_i]
                if reIns2.nil?
                    result[t.examDate.strftime("%Y").to_i][t.examDate.strftime("%m").to_i][t.examDate.strftime("%d").to_i] = []
                    reIns2 = result[t.examDate.strftime("%Y").to_i][t.examDate.strftime("%m").to_i][t.examDate.strftime("%d").to_i]
                end

                
                ins = {
                    id:t.id,
                    title:t.title,
                    content:t.content,
                    date:t.examDate,
                    position:t.position,
                    label:"試験"
                }
                reIns2.push(ins)
                result[t.examDate.strftime("%Y").to_i][t.examDate.strftime("%m").to_i][t.examDate.strftime("%d").to_i] = reIns2
            end
            if result
                mes = "試験を取得しました"
            else
                mes = "試験の取得に失敗しました。"
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
                                              exams:result
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
            #sessionが有効だったら試験を作る
            result,mes = Exam.check_and_create(@user.id, params[:title], params[:content], params[:examdate], params[:position])
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
