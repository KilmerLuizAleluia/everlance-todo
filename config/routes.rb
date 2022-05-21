Rails.application.routes.draw do
  resources :users, only: [:create, :show]
  resources :tasks

  post   'sign_in'   => 'sessions#create'
  delete 'sign_out'  => 'sessions#destroy'
end
