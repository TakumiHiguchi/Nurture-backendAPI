FactoryBot.define do
  factory :transfer_schedule do
    beforeDate { Time.new.strftime("%Y-%m-%d") }
    afterDate { Time.new.strftime("%Y-%m-%d") }
  end
end
