class Api::V1::TaskController < ApplicationController
  before_action :userSignedin?, :only => [:create,:update,:destroy] #セッションの確認
  before_action :calendarOwn?, :only => [:create, :update, :destroy] #カレンダーの所有者か確認
  
  def create
    @calendar.tasks.build(create_params)
    if @calendar.save
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => 'カレンダーを作成しました',
      })
    else
      errorJson = RenderErrorJson.new()
      render json: errorJson.createError(code:'AE_0040',api_version:'v1')
    end
  end

  def update
    task = @calendar.tasks.find(params[:task_id])
    if task.update(update_params)
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "タスクを更新しました。"
      })
    else
      errorJson = RenderErrorJson.new()
      render json: errorJson.createError(code:'AE_0041',api_version:'v1')
    end
  end

  def destroy
      if @userSession && @calendarOwn
      #sessionが有効だったらタスクを作る
        ins = Task.find_by(:calendar_id => params[:calendarId],:id => params[:task_id])
        if ins.destroy
            render :json => JSON.pretty_generate({
                                              :status => 'SUCCESS',
                                              :api_version => 'v1',
                                              :mes => "タスクを削除しました。"
                                              })
        else
            render :json => JSON.pretty_generate({
                                                :status => 'Error',
                                                :api_version => 'v1',
                                                :mes => 'タスクの削除に失敗しました。'
            
                                                })
        end
      else
          render :json => JSON.pretty_generate({
                                                :status => 'Error',
                                                :api_version => 'v1',
                                                :mes => 'セッション切れ'
            
                                                })
      end
  end

  private
  def create_params
    return({
      :title => params[:title],
      :content => params[:content],
      :taskDate => params[:taskdate],
      :position => params[:position]
    })
  end

  def update_params
    return({
      :title => params[:title],
      :content => params[:content],
      :taskDate => params[:taskdate],
      :position => params[:position],
      :complete => params[:complete]
    })
  end
end
