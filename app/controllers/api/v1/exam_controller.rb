class Api::V1::ExamController < ApplicationController
  before_action :userSignedin?, :only => [:create,:update,:destroy] #セッションの確認
  before_action :calendarOwn?, :only => [:create, :update, :destroy] #カレンダーの所有者か確認

  def create
    errorJson = RenderErrorJson.new()
    result = @calendar.exams.uniq_create(
      :title => params[:title],
      :content => params[:content],
      :examdate => params[:examdate],
      :position => params[:position]
    )

    if @calendar.save && result.present?
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => '授業の移動を作成しました',
      })
    else
      render json: errorJson.createError(code:'AE_0030',api_version:'v1')
    end
  end 

  def update
    errorJson = RenderErrorJson.new()
    exam = @calendar.exams.find(params[:exam_id])
    if exam.update(update_params)
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "試験を更新しました。"
      })
    else
      render json: errorJson.createError(code:'AE_0031',api_version:'v1')
    end
  end

  def destroy
    errorJson = RenderErrorJson.new()
    exam = @calendar.exams.find(params[:exam_id])
    if exam.delete
      render :json => JSON.pretty_generate({
        :status => 'SUCCESS',
        :api_version => 'v1',
        :mes => "試験を削除しました。"
      })
    else
      render json: errorJson.createError(code:'AE_0032',api_version:'v1')
    end
  end
  
  private
  def update_params
    return({
      :title => params[:title],
      :content => params[:content],
      :examDate => params[:examdate],
      :position => params[:position],
      :complete => params[:complete]
    })
  end
end
