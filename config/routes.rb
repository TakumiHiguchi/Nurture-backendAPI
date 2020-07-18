Rails.application.routes.draw do
    namespace 'api' do
        namespace 'v1' do
            resources :schedule
            resources :user_schedule, only:[:index,:create,:update]
            delete 'user_schedule' => 'user_schedule#destroy'
            resources :task ,only:[:index,:create]
            delete 'task' => 'task#destroy'
            patch 'task' => 'task#update'
            delete 'exam' => 'exam#destroy'
            resources :exam ,only:[:index,:create,:update]
            resources :change_schedule ,only:[:index,:create,:update]
            get 'userLogin' =>  'user#login'
            post 'setUserSchedule' => 'user#setUserSchedule'
            get 'loadUserDetail' =>  'user#loadUserDetail'
            post 'setGrade' => 'setting#setGrade'
            post 'setSemesterDate' => 'setting#setSemesterDate'
            
        end
    end
end
