Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  scope :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        omniauth_callbacks: 'users/omniauth_callbacks'
      }
      
      resources :movies, only: [:create, :update, :show]
      resources :tags, only: [:create, :update]
      get '/search' => 'search#show'
      get '/search/latest' => 'search#latest'
      get '/movie_fetch/:youtubeID' => 'movies#fetch' # via: [ :get, :post ]
      get '/users/' => 'users#show'
      put '/users/' => 'users#update'

    end
  end
  root 'home#about'
end
