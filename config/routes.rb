Rails.application.routes.draw do
  root "tasks#index"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :users do
    member do
      get :edit
      patch :update
    end
  end

  resources :tasks do
    member do
      get :edit
      patch :update
      delete :delete
    end
  end

  resources :categories
end
