require 'rails_helper'

describe 'settingAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_user_detail) }
	let(:create_calendar){ FactoryBot.create(:calendar, :with_user) }

	describe 'post /api/v1/setGrade' do
		context 'サインインしている時' do
			before do
				@user = create_user
				@params ={
					:key => @user.key,
					:session => @user.session,
					:grade => 3
				}
			end

			it '学年が更新されること' do
				post '/api/v1/setGrade', params: @params
				expect( UserDetail.find_by(user_id: @user.id).grade ).to eq( @params[:grade] )
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

	describe 'post /api/v1/setSemesterDate' do
		context 'サインインしている時' do
			before do
				@params ={
					:key => create_calendar.users.first.key,
					:session => create_calendar.users.first.session,
					:calendarId => create_calendar.id,
					:grade => 3,
					:date1 => '2020-01-01',
					:date2 => '2020-05-01',
					:date3 => '2020-08-01',
					:date4 => '2020-12-01',
				}
			end

			it '学期の期間が更新されること' do
				post '/api/v1/setSemesterDate', params: @params
				expect(response.status).to eq(401)
				expect( SemesterPeriod.find_by(calendar_id: create_calendar.id).fh_semester_f.strftime("%Y-%m-%d") ).to eq( @params[:date1] )
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



