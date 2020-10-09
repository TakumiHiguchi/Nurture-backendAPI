require 'rails_helper'

describe 'calendar_shareAPI' do
	let(:create_calendar){ FactoryBot.create(:with_all_element) }
	let(:create_other_author_calendar){ FactoryBot.create_list(:with_all_element, 2) }


	describe 'get /api/v1/calendar_search' do
		context 'サインインしている時' do
			context 'DBにユーザーのカレンダーしかなかった時' do
				before do
					get '/api/v1/calendar_search?key=' + create_calendar.users.first.key + '&session=' + create_calendar.users.first.session
					@json = JSON.parse(response.body)
				end

				it '200ステータスが帰ってくること' do
					expect(response.status).to eq(200)
				end

				it 'データが返されていないこと' do
					expect(@json["calendars"].present?).to eq(false)
				end
			end
			context 'DBにユーザー以外のカレンダーあった時' do
				before do
					get '/api/v1/calendar_search?key=' + create_other_author_calendar.first.users.first.key + '&session=' + create_other_author_calendar.first.users.first.session
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
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				get '/api/v1/calendar'
				expect(response.status).to eq(401)
			end
		end
	end

	describe 'post /api/v1/calendar_clone' do
		context 'サインインしている時' do
			before do
				@params = {
					:calendarId => create_calendar.id,
					:key => create_calendar.users.first.key,
					:session => create_calendar.users.first.session
				}
			end
			it 'カレンダーが一つ作成されていること' do
				expect { post '/api/v1/calendar_clone', params: @params }.to change(Calendar, :count).by(1)
			end
			it 'カレンダーが複製されること' do
				source = Calendar.find(@params[:calendarId])

				# 正しい個数が生成されているかの確認
				expect( Calendar.last.tasks.count ).to eq( create_calendar.tasks.count )
				expect( Calendar.last.exams.count ).to eq( create_calendar.exams.count )
				expect( Calendar.last.change_schedules.count ).to eq( create_calendar.change_schedules.count )
				expect( Calendar.last.calendar_schedule_relations.count ).to eq( create_calendar.calendar_schedule_relations.count )
				expect( Calendar.last.semester_periods.count ).to eq( create_calendar.semester_periods.count )
				expect( Calendar.last.transfer_schedules.count ).to eq( create_calendar.transfer_schedules.count )

				# 正しく複製されているかの確認
				expect( Calendar.last.tasks.first ).to eq( create_calendar.tasks.first )
				expect( Calendar.last.exams.first ).to eq( create_calendar.exams.first )
				expect( Calendar.last.change_schedules.first ).to eq( create_calendar.change_schedules.first )
				expect( Calendar.last.calendar_schedule_relations.first ).to eq( create_calendar.calendar_schedule_relations.first )
				expect( Calendar.last.semester_periods.first ).to eq( create_calendar.semester_periods.first )
				expect( Calendar.last.transfer_schedules.first ).to eq( create_calendar.transfer_schedules.first )
			end
			it '200ステータスが帰ってくること' do
				post '/api/v1/calendar_clone', params: @params
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



