require 'rails_helper'

describe 'scheduleAPI' do
	let(:set_schedules){ FactoryBot.create_list(:schedule, 100) }
	describe 'get /api/v1/schedule' do
		context 'スケジュールがあった時' do
			before do
				set_schedules
				get '/api/v1/schedule'
				@json = JSON.parse(response.body)
			end

			it 'レスポンスが200であること' do
				expect(response.status).to eq(200)
			end

			it 'スケジュールが50件取得できること' do
				expect(@json['schedules'].length).to eq(50)
				expect(@json['data_count']).to eq(50)
			end

			it '正しいプロパティが返されていること' do
				expect(@json.keys).to include('status', 'api_version', 'data_count', 'schedules')
				expect(@json["schedules"][0].keys).to include('id', 'title', 'CoNum', 'teacher', 'semester', 'position', 'grade', 'status')
			end
		end
		context 'スケジュールがなかった時' do
			before do
				get '/api/v1/schedule'
				@json = JSON.parse(response.body)
			end

			it 'レスポンスが200であること' do
				expect(response.status).to eq(200)
			end

			it 'スケジュールが0件であること' do
				expect(@json['schedules'].length).to eq(0)
			end
		end
	end
end



