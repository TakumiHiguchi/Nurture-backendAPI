FactoryBot.define do
  factory :semester_period do
  grade { rand(9) + 1 }
  fh_semester_f { Time.new.strftime("%Y-%m-%d") }
  fh_semester_s { Time.new.strftime("%Y-%m-%d") }
  late_semester_f { Time.new.strftime("%Y-%m-%d") }
  late_semester_s { Time.new.strftime("%Y-%m-%d") }
  end
end
