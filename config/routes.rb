Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:show, :update, :destroy] do
      resources :games, only: [:index, :create, :destroy]
      resources :next_games, only: [:index]
    end
  end

  post '/signup' => 'users#create'
  get '/session' => 'users#show'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
end
