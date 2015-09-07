Rails.application.routes.draw do
  get "admin/index"
  resources :admin
  resources :users
  resources :urls
  resources :hits
  root "welcome#index"
  get "/index"=> "welcome#index"

  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy", as: :logout

  get "/:path" => "urls#router"

end
