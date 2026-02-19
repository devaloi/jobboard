Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :jobs, only: %i[index show] do
    member do
      post :apply
      post :save_job
      delete :unsave_job
    end
  end

  namespace :employer do
    get "dashboard", to: "dashboard#show"
    resources :jobs do
      resources :applications, only: %i[index], controller: "applications"
    end
    resources :applications, only: [] do
      member do
        patch :status
      end
    end
  end

  namespace :seeker do
    get "dashboard", to: "dashboard#show"
    resources :applications, only: %i[index]
    resources :saved, only: %i[index], controller: "saved"
  end

  namespace :admin do
    get "dashboard", to: "dashboard#show"
    resources :jobs, only: %i[index show destroy]
    resources :users, only: %i[index show]
  end

  root "home#index"
end
