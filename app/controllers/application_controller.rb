class ApplicationController < ActionController::API
  def userSignedin?
    #sessionの確認
    errorJson = RenderErrorJson.new()
    @user = User.find_by(:key => params[:key],:session => params[:session])
    @userSession = @user.maxAge.to_i > Time.now.to_i if @user
    render json: errorJson.createError(code:'AE_0002',api_version:'v1') if !@userSession
  end

  def calendarOwn?
    calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", @user.id).where("calendars.id = ?", params[:calendarId]).where("calendars.author_id = ?", @user.id)
    @calendarOwn = calendar.length > 0
  end
end
