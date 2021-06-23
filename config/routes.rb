Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resources :users do
      collection do
        get '/current-user', to: 'users#userBySessionToken'
      end
    end

    # resources :session, only: [:create, :destroy]
    post '/session', to: 'session#create'
    delete '/session', to: 'session#destroy'
  end

  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
end
