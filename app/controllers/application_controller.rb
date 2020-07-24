class ApplicationController < ActionController::API
    
    def userSignedin?
        #sessionの確認
        @user = User.find_by(key: params[:key],session: params[:session])
        @userSession = @user.maxAge.to_i > Time.now.to_i if @user
    end

    def calendarOwn?
        calendar = User.joins(:calendars).select("users.*, calendars.*").where("users.id = ?", @user.id).where("calendars.id = ?", params[:calendarId]).where("calendars.author_id = ?", @user.id)
        @calendarOwn = calendar.length > 0
    end
    
end
