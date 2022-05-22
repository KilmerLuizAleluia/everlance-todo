Rails.application.routes.draw do
  resources :users, only: :create
  resources :tasks

  post '/auth/login', to: 'authentication#login'
end
