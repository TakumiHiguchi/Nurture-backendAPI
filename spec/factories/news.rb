FactoryBot.define do
  factory :user do
    title { Faker::Lorem.sentence }
    date { Time.new.strftime("%Y-%m-%d") }
    link { 'https://example.example.com' }
    base_title { "日本大学" }
    base_link { 'https://example.example.com' }
  end
end
