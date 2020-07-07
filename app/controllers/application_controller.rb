class ApplicationController < ActionController::API
    
    def userSignedin?
        #sessionの確認
        @user = User.find_by(key: params[:key],session: params[:session])
        @userSession = @user.maxAge.to_i > Time.now.to_i if @user
    end
end
