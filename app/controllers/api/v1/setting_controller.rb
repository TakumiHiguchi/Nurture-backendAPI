class Api::V1::SettingController < ApplicationController
  before_action :userSignedin?, :only => [:setGrade, :setSemesterDate] #セッションの確認
  before_action :calendarOwn?, :only => [:setSemesterDate] #カレンダーの所有者か確認
	def setGrade
		errorJson = RenderErrorJson.new()
		@user.user_detail.update(:grade => params[:grade])
		if @user.save
			render :json => JSON.pretty_generate({
				:status => 'SUCCESS',
				:api_version => 'v1',
				:mes => '学年を更新しました'
			})
		else
			render json: errorJson.createError(code:'AE_0100',api_version:'v1')
		end
	end
    
    def setSemesterDate
        #sessionの確認
        user = User.find_by(:key => params[:key],:session => params[:session])
        userSession = user.maxAge.to_i > Time.now.to_i if user
        calendar = Calendar.find_by(:id => params[:calendarId])
        
        if userSession && Time.parse(params[:date1]) < Time.parse(params[:date2]) && Time.parse(params[:date2]) < Time.parse(params[:date3]) && Time.parse(params[:date3]) < Time.parse(params[:date4])
            if calendarOwn(user.id ,params[:calendarId]) && user.id == calendar.author_id
                sP = SemesterPeriod.find_by(:calendar_id => params[:calendarId], :grade => params[:grade])
                if !sP
                    result = SemesterPeriod.create!(:calendar_id => params[:calendarId], :grade => params[:grade], :fh_semester_f => params[:date1], :fh_semester_s => params[:date2], :late_semester_f => params[:date3], :late_semester_s => params[:date4])
                    mes = "期間を新しく作りました。"
                else
                    result = sP.update(:calendar_id => params[:calendarId], :grade => params[:grade], :fh_semester_f => params[:date1], :fh_semester_s => params[:date2], :late_semester_f => params[:date3], :late_semester_s => params[:date4])
                    mes = "期間を更新しました。"
                end
            else
                result = false
                mes = "カレンダーを所有していません"
            end
            
        else
            result = false
            mes = "セッションが無効です"
        end
        
        if result
            render :json => JSON.pretty_generate({
                                              :status => 'SUCCESS',
                                              :api_version => 'v1',
                                              :mes => mes
            })
        else
            render :json => JSON.pretty_generate({
                                              :status => 'ERROR',
                                              :api_version => 'v1',
                                              :mes => mes
            })
        end
    end
    def calendarOwn(user_id ,cal_id)
        calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", user_id).where("calendars.id = ?", cal_id).where("calendars.author_id = ?", user_id)
        return calendar.length > 0
    end
end
