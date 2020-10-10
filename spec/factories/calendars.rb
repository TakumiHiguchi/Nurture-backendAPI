FactoryBot.define do
  factory :calendar do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    color { "#00aced" }
    shareBool { true }
    cloneBool { true }
    key { BaseWorker.new.get_key }
    author_id { Calendar.count + 1 }

    trait :with_user do
      after(:create) do |calendar|
        calendar.users << create(:user, :with_user_detail)
      end
    end

    trait :with_task do
      after(:create) do |calendar|
        calendar.tasks << create(:task)
      end
    end

    trait :with_exam do
      after(:create) do |calendar|
        calendar.exams << create(:exam)
      end
    end

    trait :with_schedule do
      after(:create) do |calendar|
        calendar.schedules << create(:schedule)
        calendar.calendar_schedule_relations.first.update(reges_grade: 1)
      end
    end

    trait :with_change_schedule do
      after(:create) do |calendar|
        calendar.change_schedules << create(:change_schedule)
      end
    end

    trait :with_semester_period do
      after(:create) do |calendar|
        calendar.semester_periods << create(:semester_period)
      end
    end

    trait :with_transfer_schedule do
      after(:create) do |calendar|
        calendar.transfer_schedules << create(:transfer_schedule)
      end
    end

    factory :with_all_element, traits: [
      :with_user,
      :with_task,
      :with_exam,
      :with_schedule,
      :with_change_schedule,
      :with_semester_period,
      :with_transfer_schedule
    ]
  end
end
