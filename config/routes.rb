Rails.application.routes.draw do
    namespace 'api' do
        namespace 'v1' do
            resources :schedule, only:[:index,:create]
            resources :user_schedule, only:[:index,:create,:update]
            delete 'user_schedule' => 'user_schedule#destroy'
            resources :task ,only:[:index,:create]
            delete 'task' => 'task#destroy'
            patch 'task' => 'task#update'
            delete 'exam' => 'exam#destroy'
            patch 'exam' => 'exam#update'
            resources :exam ,only:[:index,:create]
            delete 'change_schedule' => 'change_schedule#destroy'
            resources :change_schedule ,only:[:index,:create]
            resources :news, only:[:index]
            get 'userLogin' =>  'login#login'
            post 'setUserSchedule' => 'user#setUserSchedule'
            get 'loadUserDetail' =>  'user#loadUserDetail'
            post 'setGrade' => 'setting#setGrade'
            post 'setSemesterDate' => 'setting#setSemesterDate'
            
            resources :calendar, only:[:index,:create,:update]
            delete 'calendar' => 'calendar#destroy'
            get 'calendar_search' => 'calendar_share#search'
            post 'calendar_clone' => 'calendar_share#clone'
            post 'calendar_follow' => 'calendar_share#follow'

            resources :user, only:[:update]
            
        end
    end
end
