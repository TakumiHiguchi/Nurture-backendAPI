class Calendar < ApplicationRecord
  #バリデーション
  validates :key,         :presence => true, :length => { :in => 1..512 }
  validates :name,        :presence => true, :length => { :in => 1..150 }
  validates :description, :length => { :in => 0..100000 }

  #アソシエーション
  has_many :user_calendar_relations
  has_many :users, :through => :user_calendar_relations
  has_many :calendar_schedule_relations, :dependent => :destroy
  has_many :schedules, :through => :calendar_schedule_relations
  has_many :tasks, :dependent => :destroy
  has_many :exams, :dependent => :destroy
  has_many :change_schedules, :dependent => :destroy
  has_many :semester_periods, :dependent => :destroy

  def self.search(query)
    return self.all unless query
    
    keywords = query.split(/[[:blank:]]+/)
    articles = self

    keywords.each do |keyword|
      articles = articles.where("UPPER(name) LIKE ?", "%#{keyword.upcase}%").or(self.where(["UPPER(description) LIKE ?", "%#{query.upcase}%"]))
        .or(self.where(["UPPER(key) LIKE ?", "%#{query.upcase}%"])) #分割されたキーワードでの検索
    end
    
    return articles
  end

  def create_calendar_hash(user)
    tasks = []
    self.tasks.each do |task|
      tasks = task.createDatekeyArrayOfTask(tasks,self.id)
    end

    #Examを取得して格納する
    exams = Exam.createDatekeyArrayOfExam(self.id)
    #授業変更を取得して格納する
    cs0,cs1 = ChangeSchedule.createDatekeyArrayOfChangeSchedule(self.id)
    #学期の期間を取得して格納する
    sp = SemesterPeriod.loadUserPeriod(self.id)
    #スケジュール
    schedules = Schedule.loadSchedule(self.id)



    #振替
    cL1,cL2 = TransferSchedule.loadCL(self.id)

    #作成者
    authorData = User.joins(:user_details).select("users.*, user_details.*").find_by("users.id = ?", self.author_id)

    return ({
        :id => self.id,
        :user_id => user.id,
        :name => self.name,
        :description => self.description,
        :key => self.key,
        :shareBool => self.shareBool,
        :cloneBool => self.cloneBool,
        :author_id => self.author_id,
        :author_name => authorData.name,
        :color => self.color,
        :tasks => tasks,
        :exams => exams,
        :change_schedules_after => cs0,
        :change_schedules_before => cs1,
        :semesterPeriod => sp,
        :schedules => schedules,
        :transfer_schedule_after => cL1,
        :transfer_schedule_before => cL2
    })
  end

  
end
