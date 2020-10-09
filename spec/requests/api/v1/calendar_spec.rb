require 'rails_helper'

describe 'calendarAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:create_calendar){ FactoryBot.create(:calendar) }
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

	describe 'patch /api/v1/calendar/:id' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				calendar_hash[:key] = create_user.key
				calendar_hash[:session] = create_user.session

				@calendar_id = create_user.calendars.first.id
				# APIの仕様上calendarIdで入ってくるので追加している
				# フロントの広範囲のリファクタリングが必要なためフロントをリファクタリングするときに変更する
				calendar_hash[:calendarId] = @calendar_id

				patch '/api/v1/calendar/' + @calendar_id.to_s, params: calendar_hash
				@status = response.status
			end
			it 'カレンダーが更新されること' do
				calendar = Calendar.find(@calendar_id)
				expect( calendar.name ).to eq(calendar_hash[:name])
				expect( calendar.description ).to eq(calendar_hash[:description])
				expect( calendar.color ).to eq(calendar_hash[:color])
				expect( calendar.shareBool ).to eq(calendar_hash[:shareBool])
				expect( calendar.cloneBool ).to eq(calendar_hash[:cloneBool])
				expect( calendar.author_id ).to eq(calendar_hash[:author_id])
			end

			it '200ステータスが帰ってくること' do
				expect( @status ).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/calendar'
				expect(response.status).to eq(401)
			end
		end
	end

	describe 'delete /api/v1/calendar' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				@params = '?key=' + create_user.key + '&session=' + create_user.session + '&calendarId=' + create_user.calendars.first.id.to_s
			end
			it 'カレンダーが削除されること' do
				expect { delete '/api/v1/calendar' + @params }.to change(Calendar, :count).by(-1)
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



