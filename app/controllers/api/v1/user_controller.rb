class Api::V1::UserController < ApplicationController
    require 'digest/sha2' #ハッシュ
    require 'date'
    
    def login
        user = GoogleConfiguration.new
        userData = user.userData(params[:token])
        
        if !userData.nil?
            userKey = Digest::SHA256.hexdigest(userData["email"] + userData["sub"] + "Google")
            userName = userData["name"]
            pictureURL = userData["picture"]
            session = Digest::SHA256.hexdigest(rand(1000000000).to_s + userKey + Time.now.to_i.to_s)
            
            user,ex,sessionAge = User.exists_and_create(userKey,session)
            
            ex ? mes="お帰りなさい#{userName}さん" : mes="こんにちは。#{userName}さん"
            
            render json: JSON.pretty_generate({
                                              status:'SUCESS',
                                              api_version: 'v1',
                                              mes:mes,
                                              userKey: userKey,
                                              userName: userName,
                                              pictureURL: pictureURL,
                                              session: session,
                                              maxAge: sessionAge
            })
        else
            render json: JSON.pretty_generate({
                                              status:'ERROR',
                                              api_version: 'v1',
                                              mes:"ログインに失敗しました。",
            })
        end
    end
end
