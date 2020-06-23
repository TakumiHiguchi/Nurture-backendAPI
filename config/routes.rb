Rails.application.routes.draw do
    namespace 'api' do
        namespace 'v1' do
            resources :schedule
            get 'userLogin' =>  'user#login'
            post 'setUserSchedule' => 'user#setUserSchedule'
            get 'loadSchedule' =>  'user#loadSchedule'
        end
    end
end
