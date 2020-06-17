# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Schedule.create!(
  [
    {
      title:"人工知能1",
      CoNum:"G610628101",
      teacher:"和泉　勇治",
      semester:"前学期",
      position:0,
      grade:3,
      status: "コース選択必修 コース選択"
    },
    {
      title:"人工知能1",
      CoNum:"G610628101",
      teacher:"和泉　勇治",
      semester:"前学期",
      position:0,
      grade:3,
      status: "コース選択必修 コース選択"
    },
    {
      title:"人工知能1",
      CoNum:"G610628101",
      teacher:"和泉　勇治",
      semester:"前学期",
      position:0,
      grade:3,
      status: "コース選択必修 コース選択"
    }
  ]
)
42.times do |n|
  Schedule.create!(
                   title:"人工知能1"+n.to_s,
    CoNum:"G610628101",
    teacher:"和泉　勇治",
    semester:"前学期",
    position:n-1,
    grade:3,
    status: "コース選択必修 コース選択"
  )
end
