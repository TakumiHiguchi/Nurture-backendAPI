FactoryBot.define do
  factory :user_detail do
    name { Faker::Name.name }
    grade { rand(9) + 1 }
  end
end
