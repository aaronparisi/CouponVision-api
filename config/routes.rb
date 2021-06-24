Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resources :users do
      collection do
        get '/current-user', to: 'users#userBySessionToken'
      end
    end

    resources :brands do
      
    end

    resources :coupon_stores do
      
    end

    resources :coupons do
      
    end

    resources :grocers do
      
    end

    resources :products do
      
    end

    resources :stores do
      collection do
        get 'total_savings', to: 'stores#total_savings'
      end
    end

    # resources :session, only: [:create, :destroy]
    post '/session', to: 'session#create'
    delete '/session', to: 'session#destroy'
  end

  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
end
