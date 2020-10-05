class User < ApplicationRecord
  #バリデーション
  validates :key,        :presence => true, :length => { :maximum => 512 }

  #アソシエーション
  has_many :user_calendar_relations
  has_many :calendars, :through => :user_calendar_relations
  has_one :user_detail


  def self.exists_and_create(key,ses)
    maxAge = Time.now.to_i + 3600
    if user = self.find_by(:key => key)
      user.update(:session => ses, :maxAge => maxAge) 
      return true ,maxAge
    else
      self.create(:key => key, :session => ses, :maxAge => maxAge)
      return false ,maxAge
    end
  end

  def self.sign_in(props)
    user_key = Digest::SHA256.hexdigest(props[:user_data]["email"] + props[:user_data]["sub"] + "Google")
    user_name = props[:user_data]["name"]
    pictureURL = props[:user_data]["picture"]
    session = Digest::SHA256.hexdigest(rand(1000000000).to_s + user_key + Time.now.to_i.to_s)

    user_exsist,sessionAge = self.exists_and_create(user_key, session)
    user = self.find_by(:key => user_key)
    if !user_exsist
      base_worker = BaseWorker.new
      #UserDetailの作成
      UserDetail.create(:user_id => user.id, :grade => 1, :name => user_name)
      #カレンダーの作成
      user.calendars.create(:name => user_name+"のカレンダー" , :description => "", :key => base_worker.get_key, :author_id => user.id)
      user.save
    end
    user_exsist ? mes="お帰りなさい#{user.user_detail.name}さん" : mes="こんにちは。#{user_name}さん"

    return({
      :status => 'SUCCESS',
      :api_version => 'v1',
      :mes => mes,
      :userKey => user_key,
      :userName => user_name,
      :pictureURL => pictureURL,
      :session => session,
      :maxAge => sessionAge,
      :grade => user.user_detail.grade,
      :created_at => user.created_at
    })
  end
end
