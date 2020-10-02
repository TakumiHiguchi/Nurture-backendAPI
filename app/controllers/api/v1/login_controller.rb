class Api::V1::LoginController < ApplicationController
  def login
    user = GoogleConfiguration.new
    userData = user.userData(params[:token])
    
    if !userData.nil?
        if params[:sns] == "google"
            userKey = Digest::SHA256.hexdigest(userData["email"] + userData["sub"] + "Google")
            userName = userData["name"]
            pictureURL = userData["picture"]
            session = Digest::SHA256.hexdigest(rand(1000000000).to_s + userKey + Time.now.to_i.to_s)
            
            user,ex,sessionAge = User.exists_and_create(userKey,session)

            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
            key = (0...20).map { o[rand(o.length)] }.join
            
            
            if !ex
              #新規ユーザー
              #ユーザーの情報を取得
              u = User.find_by(:key => userKey,:session => session)

              #UserDetailの作成
              UserDetail.create(:user_id => u.id, :grade => 1, :name => userName)

              #カレンダーの作成
              Calendar.create(:name => userName+"のカレンダー" , :description => "", :key => key, :author_id => u.id)
              cal = Calendar.find_by(:key => key)

              #ユーザーカレンダーのリレーションを作成
              UserCalendarRelation.create(:user_id => u.id, :calendar_id => cal.id)

            end
        end
        
        
        u = User.joins(:user_details).select("users.*, user_details.*, users.id AS user_id").find_by(:key => userKey,:session => session)
        ex ? mes="お帰りなさい#{u.name}さん" : mes="こんにちは。#{u.name}さん"
        #ユーザが登録した学期の期間を整形して配列で返す処理
        #semesterDate = SemesterPeriod.loadUserPeriod(u.id)
        
        render :json => JSON.pretty_generate({
                                          :status => 'SUCCESS',
                                          :api_version => 'v1',
                                          :mes => mes,
                                          :userKey => userKey,
                                          :userName => u.name,
                                          :pictureURL => pictureURL,
                                          :session => session,
                                          :maxAge => sessionAge,
                                          :grade => u.grade,
                                          :created_at => u.created_at
        })
    else
        render :json => JSON.pretty_generate({
                                          :status => 'ERROR',
                                          :api_version => 'v1',
                                          :mes => "ログインに失敗しました。",
        })
    end
  end
end
