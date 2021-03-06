class ApplicationController < ActionController::API
  def userSignedin?
    #sessionの確認
    errorJson = RenderErrorJson.new()
    @user = User.find_by(:key => params[:key],:session => params[:session])
    @userSession = @user.maxAge.to_i > Time.now.to_i if @user
    render status: 401, json: errorJson.createError(status: 401, code: 'AE_0001', api_version: 'v1') if !@userSession
  end

  def calendarOwn?
    errorJson = RenderErrorJson.new()
    @calendar = @user.calendars.find_by(:id => params[:calendarId], :author_id => @user.id)
    render status: 404, json: errorJson.createError(status: 404, code: 'AE_0002', api_version: 'v1') if @calendar.nil?
  end
end
