Rails.application.routes.draw do
  root 'home#index'

  resource :policies, only: [:new, :create]

  get '/new_policies', to: 'policies#new'
  post '/create_policies', to: 'policies#create'

  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
end
