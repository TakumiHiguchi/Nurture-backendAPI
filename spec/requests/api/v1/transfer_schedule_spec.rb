require 'rails_helper'

describe 'transfer_scheduleAPI' do
	let(:create_transfer_schedule){ FactoryBot.create(:calendar, :with_transfer_schedule, :with_user) }
	let(:transfer_schedule_hash){ FactoryBot.attributes_for(:transfer_schedule) }

	describe 'post /api/v1/transfer_schedule' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				transfer_schedule_hash[:key] = create_transfer_schedule.users.first.key
				transfer_schedule_hash[:session] = create_transfer_schedule.users.first.session
				transfer_schedule_hash[:calendarId] = create_transfer_schedule.id
			end
			it 'カレンダーが作成されること' do
				expect { post '/api/v1/transfer_schedule', params: transfer_schedule_hash }.to change(TransferSchedule, :count).by(1)
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
