Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      devise_scope :user do
        post "sign_in",  to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "users", to: "registrations#create"
      end

      get "current_user", to: "users#current"
      resource :users, only: [] do
        get 'me', to: 'users#current'
        put 'me', to: 'users#update'
      end

      resources :items, only: [:index, :show] do
        collection do
          get :search
        end
      end

      resources :orders, only: [:index, :show]
      post "checkout", to: "orders#checkout"

      namespace :admin do
        resources :users, only: [:index, :update, :destroy, :create]
        resources :items, only: [:index, :update, :destroy, :create] do
          member do
            post :restore
          end
        end
        resources :orders, only: [:index, :show]
      end

    end
  end
end
