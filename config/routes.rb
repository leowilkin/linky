Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # Authentication routes (must be before wildcard)
  get '/login', to: 'sessions#new'
  # OmniAuth handles /auth/:provider via middleware (POST only)
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  delete '/logout', to: 'sessions#destroy'
  
  resources :links

  get '/search', to: 'search#index'

  get '/settings', to: 'settings#index'
  patch '/settings', to: 'settings#update'

  root to: 'links#index'

  # Quick link creation - /s/ prefix for manual creation
  get '/s/*url', to: 'links#new'

  # Catch-all wildcard - handles both quick create and regular redirects
  match '*path', to: 'redirect#index', via: :get, constraints: lambda { |req| 
    !req.path.start_with?('/auth', '/links', '/search', '/login', '/logout', '/settings', '/rails')
  }

end
