require 'rails_helper'

describe 'newsAPI' do
	let(:create_news){ FactoryBot.create(:news) }
	describe 'get /api/v1/news' do
		context 'ニュースがあった時' do
			before do
				get '/api/v1/news'
				@json = JSON.parse(response.body)
			end

			it '正しいプロパティが返されていること' do
				expect(@json.keys).to include('status', 'api_version', 'calendars')
				expect(@json["NUnews"][0].keys).to include(
					"title",
					"date",
					"link",
					"base_title",
					"base_link"
				)
			end

			it '200ステータスが帰ってくること' do
				expect(response.status).to eq(200)
			end
		end
	end
end



