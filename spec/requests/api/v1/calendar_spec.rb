require 'rails_helper'

describe 'calendarAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:calendar_hash){ FactoryBot.attributes_for(:calendar) }

	describe 'get /api/v1/calendar' do
		context 'サインインしている時' do
			before do
				get '/api/v1/calendar?key=' + create_user.key + '&session=' + create_user.session
				@json = JSON.parse(response.body)
			end

			it '200ステータスが帰ってくること' do
				expect(response.status).to eq(200)
			end

			it '正しいプロパティが返されていること' do
				expect(@json.keys).to include('status', 'api_version', 'calendars')
				expect(@json["calendars"][0].keys).to include(
					'id',
					'user_id',
					'name',
					'description',
					'key',
					'shareBool',
					'cloneBool',
					'author_id',
					'author_name',
					'color',
					'tasks',
					'exams',
					'change_schedules_after',
					'change_schedules_before',
					'semesterPeriod',
					'schedules',
					'transfer_schedule_after',
					'transfer_schedule_before'
				)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				get '/api/v1/calendar'
				expect(response.status).to eq(401)
			end
		end
	end

	describe 'post /api/v1/calendar' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				calendar_hash[:key] = create_user.key
				calendar_hash[:session] = create_user.session
			end
			it 'カレンダーが作成されること' do
				expect { post '/api/v1/calendar', params: calendar_hash }.to change(Calendar, :count).by(1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/calendar'
				expect(response.status).to eq(401)
			end
		end
	end
end



