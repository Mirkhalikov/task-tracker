Rails.application.routes.draw do
  root "tasks#index"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :tasks do
    member do
      get :edit
      patch :update
      delete :destroy
    end
  end

  resources :categories
end
