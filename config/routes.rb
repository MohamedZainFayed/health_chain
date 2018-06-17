Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

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
  
end
