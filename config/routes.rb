Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations' }

  devise_scope :user do
    post "/users/sessions/verify_otp" => "users/sessions#verify_otp"

    authenticated :user do
      root 'welcome#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :two_factor do
    collection do
      get :activate
      get :deactivate
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
  get "/dashboard" => "dashboard#index"
  post "/user_auth" => "api#user_auth"
  post "/email_activated" => "api#email_activated"
  get "/new_doctor" => "dashboard#new_doctor"
  get "/new_patient" => "dashboard#new_patient"
  post "/dashboard/add_doctor" => "dashboard#create_doctor"
  post "/dashboard/add_patient" => "dashboard#create_patient"
  post "/dashboard/get_info" => "dashboard#get_info"
  post "/dashboard/add_record" => "dashboard#add_record"
  match '/dashboard/delete_doctor/:id' => 'dashboard#delete_doctor', via: [:delete]
  get "/show_patient" => "dashboard#show_patient"
end
