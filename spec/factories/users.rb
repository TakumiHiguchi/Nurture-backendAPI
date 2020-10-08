FactoryBot.define do
  factory :user do
    base_worker = BaseWorker.new
    key = base_worker.get_key

    key { key }
    session { Digest::SHA256.hexdigest(key) }
    maxAge { Time.now.to_i + 3600 }

    trait :with_calendar do
      after(:create) do |user|
        user.calendars << create(:calendar)
      end
    end

    trait :with_user_detail do
      after(:create) do |user|
        FactoryBot.create(:user_detail, user: user) 
      end
    end
  end
end
