Rails.application.routes.draw do
  root to: 'panel/appointments#index'

  namespace :panel do
    get 'appointments' => 'appointments#index'
    post 'appointments' => 'appointments#create'

    get 'appointments/schedule' => 'appointments#schedule'

    get 'appointments/new' => 'appointments#new'
    delete 'appointments/:id' => 'appointments#destroy'

    get '/logout', to: 'sessions#logout', as: 'logout'
  end

  namespace :admin do
    root to: 'schedule#index'

    resources :unavailable_days, only: [:index, :create, :destroy]

    resources :schedule, only: [:index] do
      member do
        put :confirm_presence
        put :confirm_absence
      end
    end

    get '/logout', to: 'sessions#logout', as: 'logout'
  end
end
