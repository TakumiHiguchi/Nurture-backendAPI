Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :schedule, :only => [:index,:create]
      delete 'user_schedule' => 'user_schedule#destroy'
      resources :task ,:only => [:create,:update]
      delete 'task' => 'task#destroy'
      delete 'exam' => 'exam#destroy'
      resources :exam ,:only => [:create, :update]
      delete 'change_schedule' => 'change_schedule#destroy'
      resources :change_schedule ,:only => [:index,:create]
      resources :news, :only => [:index]
      get 'userLogin' =>  'login#login'
      post 'setUserSchedule' => 'user#setUserSchedule'
      get 'loadUserDetail' =>  'user#loadUserDetail'
      post 'setGrade' => 'setting#setGrade'
      post 'setSemesterDate' => 'setting#setSemesterDate'
      
      resources :calendar, :only => [:index,:create,:update]
      delete 'calendar' => 'calendar#destroy'
      get 'calendar_search' => 'calendar_share#search'
      post 'calendar_clone' => 'calendar_share#clone'
      post 'calendar_follow' => 'calendar_share#follow'
      delete 'calendar_destroy_follow' => 'calendar_share#destroy_follow'

      resources :user, :only => [:update]
      resources :canceled_lecture, :only => [:index,:create,:update]
      resources :transfer_schedule, :only => [:create,:destroy]
    end
  end
end
