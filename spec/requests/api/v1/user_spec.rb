require 'rails_helper'

describe 'transfer_scheduleAPI' do
	let(:create_schedule){ FactoryBot.create(:schedule) }
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }

	describe 'post /api/v1/setUserSchedule' do
		context 'サインインしている時' do
			before do
				@params = {
					:title => create_schedule.title,
					:teacher => create_schedule.teacher,
					:semester => create_schedule.semester,
					:position => create_schedule.position,
					:grade => create_schedule.grade,
					:key => create_user.key,
					:session => create_user.session,
					:calendarId => create_user.calendars.first.id
				}
			end
			it 'カレンダーとスケジュールが紐付けられること' do
				expect { post '/api/v1/setUserSchedule', params: @params }.to change(CalendarScheduleRelation, :count).by(1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/transfer_schedule'
				expect(response.status).to eq(401)
			end
		end
	end
end
