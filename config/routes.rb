Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  get    '/users/:user_id/tasks', to: 'tasks#index'
  
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    resources :tasks
  end
end
