Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:show, :update, :destroy] do
      resources :games, only: [:index, :create, :destroy]
      resources :next_games, only: [:index]
    end
  end

  get '/api/users/:user_id/games' => 'api/games#index'
  get '/api/users/:user_id/next_games' => 'api/next_games#index'
  post '/signup' => 'users#create'
  get '/session' => 'users#show'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
end
