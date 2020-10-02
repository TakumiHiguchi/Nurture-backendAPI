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
      :title => "コンピュータビジョン及び演習",
      :CoNum => "G610632102",
      :teacher => "加瀬澤",
      :semester => "前学期",
      :position => 1,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "ソフトウェア設計法及び演習",
      :CoNum => "G610615102",
      :teacher => "関澤俊",
      :semester => "前学期",
      :position => 2,
      :grade => 3,
      :status => "必修"
    },
    {
      :title => "実用英語3",
      :CoNum => "G210026102",
      :teacher => "古河美喜子",
      :semester => "前学期",
      :position => 3,
      :grade => 3,
      :status => "必修"
    },
    {
      :title => "ソフトウェア設計法及び演習",
      :CoNum => "G610615102",
      :teacher => "関澤俊弦",
      :semester => "前学期",
      :position => 4,
      :grade => 3,
      :status => "必修"
    },
    {
      :title => "オートマトンと言語及び演習",
      :CoNum => "G610610101",
      :teacher => "関澤俊弦",
      :semester => "前学期",
      :position => 7,
      :grade => 3,
      :status => "コース選択必修　コース選択"
    },
    {
      :title => "オートマトンと言語及び演習",
      :CoNum => "G610610101",
      :teacher => "関澤俊弦",
      :semester => "前学期",
      :position => 8,
      :grade => 3,
      :status => "コース選択必修　コース選択"
    },
    {
      :title => "高度オペレーティングシステム",
      :CoNum => "G610620101",
      :teacher => "西園敏弘",
      :semester => "前学期",
      :position => 9,
      :grade => 3,
      :status => "コース選択必修　コース選択"
    },
    {
      :title => "大規模ソフトウェア開発法及び演習",
      :CoNum => "G610623102",
      :teacher => "杉山安洋",
      :semester => "前学期",
      :position => 10,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "コンピュータビジョン及び演習",
      :CoNum => "G610632102",
      :teacher => "加瀬澤　正、田中　宏卓",
      :semester => "前学期",
      :position => 13,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "大規模ソフトウェア開発法及び演習",
      :CoNum => "G610623102",
      :teacher => "杉山安洋",
      :semester => "前学期",
      :position => 14,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "コンピュータネットワーク",
      :CoNum => "G610626101",
      :teacher => "上田清志",
      :semester => "前学期",
      :position => 15,
      :grade => 3,
      :status => "必修"
    },
    {
      :title => "人工知能1",
      :CoNum => "G610628101",
      :teacher => "和泉勇治",
      :semester => "前学期",
      :position => 19,
      :grade => 3,
      :status => "コース選択必修コース選択　"
    },
    {
      :title => "数値解析法",
      :CoNum => "G610606101",
      :teacher => "宮村倫司",
      :semester => "前学期",
      :position => 24,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "数値解析法演習",
      :CoNum => "G610607101",
      :teacher => "宮村倫司",
      :semester => "前学期",
      :position => 25,
      :grade => 3,
      :status => "選択必修"
    },
    {
      :title => "情報処理演習1",
      :CoNum => "G610638101",
      :teacher => "溝口知広、大山勝徳",
      :semester => "前学期",
      :position => 26,
      :grade => 3,
      :status => "選択"
    }
  ]
)
