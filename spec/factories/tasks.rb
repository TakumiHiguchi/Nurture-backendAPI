FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(500) }
    taskDate { Time.new.strftime("%Y-%m-%d") }
    position { rand(5) + 1 }
    complete { false }
  end
end
