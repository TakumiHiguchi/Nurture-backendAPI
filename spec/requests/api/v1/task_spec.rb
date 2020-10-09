require 'rails_helper'

describe 'taskAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_calendar, :with_user_detail) }
	let(:create_task){ FactoryBot.create(:calendar, :with_task, :with_user) }
	let(:task_hash){ FactoryBot.attributes_for(:task) }

	describe 'post /api/v1/task' do
		context 'サインインしている時' do
			before do
				# keyとsessionを与えてログイン状態にする
				task_hash[:key] = create_user.key
				task_hash[:session] = create_user.session
				task_hash[:calendarId] = create_user.calendars.first.id
			end
			it 'タスクが作成されること' do
				expect { post '/api/v1/task', params: task_hash }.to change(Task, :count).by(1)
				expect(response.status).to eq(200)
			end
		end
		context 'サインインしていない時' do
			it '401ステータスが帰ってくること' do
				post '/api/v1/task'
				expect(response.status).to eq(401)
			end
		end
	end
end
