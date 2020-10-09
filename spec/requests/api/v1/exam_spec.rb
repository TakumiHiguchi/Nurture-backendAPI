require 'rails_helper'

describe 'examAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:create_exam){ FactoryBot.create(:calendar, :with_exam, :with_user) }
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

	describe 'patch /api/v1/exam/:id' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				exam_hash[:key] = create_exam.users.first.key
				exam_hash[:session] = create_exam.users.first.session
				exam_hash[:calendarId] = create_exam.id

				patch '/api/v1/exam/' + create_exam.exams.first.id.to_s, params: exam_hash
				@status = response.status
			end
			it 'カレンダーが更新されること' do
				exam = Exam.find(create_exam.exams.first.id)
				expect( exam.title ).to eq(exam_hash[:title])
			end

			it '200ステータスが帰ってくること' do
				expect( @status ).to eq(200)
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
