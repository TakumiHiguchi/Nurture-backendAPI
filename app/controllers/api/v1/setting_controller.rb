class Api::V1::SettingController < ApplicationController
  before_action :userSignedin?, :only => [:setGrade, :setSemesterDate] #セッションの確認
  before_action :calendarOwn?, :only => [:setSemesterDate] #カレンダーの所有者か確認
	def setGrade
		@user.user_detail.update(:grade => params[:grade])
		if @user.save
			render :json => JSON.pretty_generate({
				:status => 'SUCCESS',
				:api_version => 'v1',
				:mes => '学年を更新しました'
			})
		else
			errorJson = RenderErrorJson.new()
			render json: errorJson.createError(code:'AE_0100',api_version:'v1')
		end
	end

	def setSemesterDate
		if SemesterDate_satisfies?
			@calendar.semester_periods.exsists_and_create(params)
			render :json => JSON.pretty_generate({
				:status => 'SUCCESS',
				:api_version => 'v1',
				:mes => '学期の期間を更新しました'
			})
		else
			errorJson = RenderErrorJson.new()
			render json: errorJson.createError(code:'AE_0101',api_version:'v1')
		end
	end

	def SemesterDate_satisfies?
		return Time.parse(params[:date1]) < Time.parse(params[:date2]) && Time.parse(params[:date2]) < Time.parse(params[:date3]) && Time.parse(params[:date3]) < Time.parse(params[:date4])
	end
end
