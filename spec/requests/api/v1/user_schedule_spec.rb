require 'rails_helper'

describe 'calendar_schedule_relationAPI' do
	let(:create_calendar){ FactoryBot.create(:calendar, :with_schedule, :with_user) }

	describe 'delete /api/v1/user_schedule' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				@params = '?key=' + create_calendar.users.first.key + '&session=' + create_calendar.users.first.session + '&calendarId=' + create_calendar.id.to_s + '&schedule_id=' + create_calendar.schedules.first.id.to_s + '&grade=1'
			end
			it 'カレンダーが削除されること' do
				expect { delete '/api/v1/user_schedule' + @params }.to change(CalendarScheduleRelation, :count).by(-1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				delete '/api/v1/user_schedule'
				expect(response.status).to eq(401)
			end
		end
	end
end
