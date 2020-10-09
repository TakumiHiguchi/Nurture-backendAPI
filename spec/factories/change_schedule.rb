FactoryBot.define do
  factory :change_schedule do
    schedule_id { 1 }
    beforeDate { Time.new.strftime("%Y-%m-%d") }
    afterDate { Time.new.strftime("%Y-%m-%d") }
    position { rand(5) + 1 }
  end
end
