class Api::V1::ExamController < ApplicationController
    before_action :userSignedin?, only: [:index,:create,:update] #セッションの確認
    
    def index
    
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
