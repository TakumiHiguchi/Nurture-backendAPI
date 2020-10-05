class Api::V1::LoginController < ApplicationController
  def login
    if params[:sns] == "google"
      user = GoogleConfiguration.new
      user_data = user.get_user_data(params[:token])
      if user_data.present?
        result = User.sign_in(user_data: user_data)
        render :json => JSON.pretty_generate(result)
      else
        errorJson = RenderErrorJson.new()
        render json: errorJson.createError(code:'SE_0001',api_version:'v1')
      end
    end
  end
end
