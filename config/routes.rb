Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  scope :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        omniauth_callbacks: 'users/omniauth_callbacks'
      }
      
      resources :movies, only: [:create, :update]
      resources :tags, only: [:create, :update]
      get '/movie_fetch/:youtubeID' => 'movies#fetch' # via: [ :get, :post ]
      get '/users/' => 'users#show'

    end
  end
  root 'home#about'
end
