class Api::V1::NewsController < ApplicationController
  def index
    nihonUniversity_news = News.where(:base_title => "日本大学")
    news = nihonUniversity_news.map do |news|
      next(
        :title => news.title,
        :date => news.date,
        :link => news.link,
        :base_title => news.base_title,
        :base_link => news.base_link
      )
    end
    render :json => JSON.pretty_generate({
      :status => 'SUCCESS',
      :api_version => 'v1',
      :NUnews => news
    })
end
end
