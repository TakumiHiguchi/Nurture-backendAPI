FactoryBot.define do
  factory :calendar do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    color { "#00aced" }
    shareBool { true }
    cloneBool { true }
    key { BaseWorker.new.get_key }
    author_id { 1 }
  end
end
