Rails.application.routes.draw do
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get '/login', to: 'sessions#new'
  # get '/home', to: 'home#index'
  root 'application#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
end
