require 'rails_helper'

describe 'settingAPI' do
	let(:create_user){ FactoryBot.create(:user, :with_user_detail) }
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
				expect( UserDetail.find(@user.id).grade ).to eq( @params[:grade] )
				expect(response.status).to eq(200)
			end
		end
	end
end



