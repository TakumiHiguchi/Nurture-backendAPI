FactoryBot.define do
  factory :schedule do
    title { Faker::Name.name }
    CoNum { Faker::Name.name }
    teacher { Faker::Name.name }
    semester { '前学期' }
    position { rand(5) }
    grade { rand(9) + 1 }
    status { '' }
  end
end
