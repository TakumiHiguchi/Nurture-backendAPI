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
  has_many :transfer_schedules, :dependent => :destroy

  #scope
  scope :include_all_tables, -> {
    includes(
      :tasks,
      :exams,
      :semester_periods,
      :change_schedules,
      :schedules,
      :transfer_schedules
    )
  }
  scope :share_only, -> {where(:shareBool => true)}
  scope :clone_only, -> {where(:shareBool => true)}
  scope :not_author, -> (user) {where.not(:author_id => user.id)}

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

    exams = []
    self.exams.each do |exam|
      exams = exam.createDatekeyArrayOfTask(exams,self.id)
    end

    #振替
    transfer_schedules_before = []
    transfer_schedules_after = []
    self.transfer_schedules.each do |transfer_schedule|
      transfer_schedules_before, transfer_schedules_after = transfer_schedule.loadCL(transfer_schedules_before, transfer_schedules_after, self.id)
    end

    #授業変更
    change_schedules_before = []
    change_schedules_after = []
    self.change_schedules.each do |change_schedule|
      change_schedules_before, change_schedules_after = change_schedule.createDatekeyArrayOfChangeSchedule(change_schedules_before, change_schedules_after, self.id)
    end

    #学期の期間
    sp = Array.new(10,{ :fhSemester1 => "2020/4/10", :fhSemester2 => "2020/7/30", :lateSemester1 => "2020/9/14", :lateSemester2 => "2021/2/22" })
    self.semester_periods.each do |semester_period|
      ins = { :fhSemester1 => semester_period.fh_semester_f.strftime("%Y/%m/%d"), :fhSemester2 => semester_period.fh_semester_s.strftime("%Y/%m/%d"), :lateSemester1 => semester_period.late_semester_f.strftime("%Y/%m/%d"), :lateSemester2 => semester_period.late_semester_s.strftime("%Y/%m/%d") }
      sp[semester_period.grade - 1] = ins
    end

    #スケジュール
    schedules = (0...10).map { (0...2).map {(0..6).map {Array.new(6,0)}}} #スケジュール配列の作成し、0で初期化
    self.schedules.each do |schedule|
      schedules = schedule.loadSchedule(schedules,self.id)
    end

    #作成者
    authorData = UserDetail.find_by(user_id: self.author_id)

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
      :change_schedules_after => change_schedules_after,
      :change_schedules_before => change_schedules_before,
      :semesterPeriod => sp,
      :schedules => schedules,
      :transfer_schedule_after => transfer_schedules_after,
      :transfer_schedule_before => transfer_schedules_before
    })
  end
  
  def clone(user)
    base_worker = BaseWorker.new
    new_calendar = user.calendars.build(
      :key => base_worker.get_key,
      :name => self.name,
      :description => self.description,
      :shareBool => self.shareBool,
      :cloneBool => self.cloneBool,
      :author_id => user.id
    )
    if user.save
      self.tasks.each{ |task| task.clone(new_calendar.id) }
      Exam.clone(self.id, new_calendar.id)
      CalendarScheduleRelation.clone(self.id, new_calendar.id)
      ChangeSchedule.clone(self.id, new_calendar.id)
      SemesterPeriod.clone(self.id, new_calendar.id)
      TransferSchedule.clone(self.id, new_calendar.id)
    else
      render json: errorJson.createError(code:'AE_0010',api_version:'v1')
    end
  end
end
