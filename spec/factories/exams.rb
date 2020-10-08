FactoryBot.define do
  factory :exam do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(500) }
    examDate { Time.new.strftime("%Y-%m-%d") }
    position { rand(5) + 1 }
    complete { false }
  end
end
