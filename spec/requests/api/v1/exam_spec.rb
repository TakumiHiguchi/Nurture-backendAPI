require 'rails_helper'

describe 'examAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:exam_hash){ FactoryBot.attributes_for(:exam) }

	describe 'post /api/v1/exam' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				exam_hash[:key] = create_user.key
				exam_hash[:session] = create_user.session
				exam_hash[:calendarId] = create_user.calendars.first.id
			end
			it 'カレンダーが作成されること' do
				expect { post '/api/v1/exam', params: exam_hash }.to change(Exam, :count).by(1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/exam'
				expect(response.status).to eq(401)
			end
		end
	end
end



