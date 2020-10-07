require 'rails_helper'

describe 'scheduleAPI' do
	let(:set_schedules){ FactoryBot.create_list(:schedule, 100) }
	let(:create_user){ FactoryBot.create(:user_detail, user: FactoryBot.create(:user)) }
	let(:set_schedule_hash){ FactoryBot.attributes_for(:schedule) }

	describe 'get /api/v1/schedule' do
		context 'スケジュールがあった時' do
			before do
				set_schedules
				get '/api/v1/schedule'
				@json = JSON.parse(response.body)
			end

			it 'レスポンスが200であること' do
				expect(response.status).to eq(200)
			end

			it 'スケジュールが50件取得できること' do
				expect(@json['schedules'].length).to eq(50)
				expect(@json['data_count']).to eq(50)
			end

			it '正しいプロパティが返されていること' do
				expect(@json.keys).to include('status', 'api_version', 'data_count', 'schedules')
				expect(@json["schedules"][0].keys).to include('id', 'title', 'CoNum', 'teacher', 'semester', 'position', 'grade', 'status')
			end
		end
		context 'スケジュールがなかった時' do
			before do
				get '/api/v1/schedule'
				@json = JSON.parse(response.body)
			end

			it 'レスポンスが200であること' do
				expect(response.status).to eq(200)
			end

			it 'スケジュールが0件であること' do
				expect(@json['schedules'].length).to eq(0)
			end
		end
	end

	describe 'post /api/v1/schedule' do
		context 'ログインしている時' do
			context '正しいパラメータの時' do
				before do
					# keyとsessionを与えてログイン状態にする
					set_schedule_hash[:key] = create_user.user.key
					set_schedule_hash[:session] = create_user.user.session

					# APIの使用上CoNumで入ってこないのでnumberで与える
					# フロントの広範囲のリファクタリングが必要なためフロントをリファクタリングするときに変更する
					set_schedule_hash[:number] = Faker::Name.name
				end

				it 'スケジュールが作成されること' do
					expect { post '/api/v1/schedule', params: set_schedule_hash }.to change(Schedule, :count).by(1)
					expect(response.status).to eq(200)
				end
			end

			context '不正なパラメータの時' do
				it '400ステータスが帰ってくること' do
					post '/api/v1/schedule', params: {:key => create_user.user.key, :session => create_user.user.session}
					expect(response.status).to eq(400)
				end
			end
		end

		context 'ログインしていない時' do
			before do
				# APIの使用上CoNumで入ってこないのでnumberで与える
				# フロントの広範囲のリファクタリングが必要なためフロントをリファクタリングするときに変更する
				set_schedule_hash[:number] = Faker::Name.name
			end

			it '401ステータスが帰ってくること' do
				post '/api/v1/schedule', params: set_schedule_hash
				expect(response.status).to eq(401)
			end
		end
	end
end



