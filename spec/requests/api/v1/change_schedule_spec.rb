require 'rails_helper'

describe 'change_scheduleAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:change_schedule_hash){ FactoryBot.attributes_for(:change_schedule) }

	describe 'post /api/v1/change_schedule' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				change_schedule_hash[:key] = create_user.key
				change_schedule_hash[:session] = create_user.session

				# APIの仕様上calendarIdで入ってくるので追加している
				# フロントの広範囲のリファクタリングが必要なためフロントをリファクタリングするときに変更する
				change_schedule_hash[:calendarId] = create_user.calendars.first.id
				change_schedule_hash[:selectSchedule_id] = 1
			end
			it '授業変更が作成されること' do
				expect { post '/api/v1/change_schedule', params: change_schedule_hash }.to change(ChangeSchedule, :count).by(1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/change_schedule'
				expect(response.status).to eq(401)
			end
		end
	end
end



