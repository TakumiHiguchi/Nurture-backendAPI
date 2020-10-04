class Api::V1::ExamController < ApplicationController
    before_action :userSignedin?, :only => [:index,:create,:update,:destroy] #セッションの確認
    before_action :calendarOwn?, :only => [:create, :update, :destroy] #カレンダーの所有者か確認
    
    def index
        if @userSession
        end
    end

    def create
        
            #sessionが有効だったら試験を作る
            result,mes = Exam.check_and_create(params[:calendarId], params[:title], params[:content], params[:examdate], params[:position])
            if result
                mes = "試験を作成しました"
            else
                mes = "試験の作成に失敗しました。"
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

    def update
        if @userSession && @calendarOwn
            #sessionが有効だったら試験を作る
            ins = Exam.find_by(:calendar_id => params[:calendarId], :id => params[:exam_id])
            ins = ins.update(:calendar_id => params[:calendarId], :title => params[:title], :content => params[:content], :examDate => params[:examdate], :position => params[:position],:complete => params[:complete])
            if ins
                render :json => JSON.pretty_generate({
                                                  :status => 'SUCCESS',
                                                  :api_version => 'v1',
                                                  :mes => "試験を更新しました。"
                                                  })
            else
                render :json => JSON.pretty_generate({
                                                    :status => 'Error',
                                                    :api_version => 'v1',
                                                    :mes => '試験の更新に失敗しました。'
                
                                                    })
            end
        end
    end
    def destroy
        if @userSession && @calendarOwn
        #sessionが有効だったらタスクを作る
          ins = Exam.find_by(:calendar_id => params[:calendarId], :id => params[:exam_id])
          if ins.destroy
              render :json => JSON.pretty_generate({
                                                :status => 'SUCCESS',
                                                :api_version => 'v1',
                                                :mes => "試験を削除しました。"
                                                })
          else
              render :json => JSON.pretty_generate({
                                                  :status => 'Error',
                                                  :api_version => 'v1',
                                                  :mes => '試験の削除に失敗しました。'
              
                                                  })
          end
        end
    end
end
