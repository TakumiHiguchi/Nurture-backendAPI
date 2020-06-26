Rails.application.routes.draw do
    namespace 'api' do
        namespace 'v1' do
            resources :schedule
            get 'userLogin' =>  'user#login'
            post 'setUserSchedule' => 'user#setUserSchedule'
            get 'loadUserDetail' =>  'user#loadUserDetail'
            post 'setGrade' => 'setting#setGrade'
            post 'setSemesterDate' => 'setting#setSemesterDate'
        end
    end
end
