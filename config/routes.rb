Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    # resources :users do
    #   collection do
    #     get '/current-user', to: 'users#userBySessionToken'
    #   end
    # end

    # resources :brands do
      
    # end

    # resources :coupon_stores do
      
    # end

    # resources :coupons do
      
    # end

    # resources :grocers do
    #   collection do
    #     get 'coupon_counts_by_brand_per_grocer', to: 'grocers#coupon_counts_by_brand'
    #     get 'coupons_by_brand_per_grocer', to: 'grocers#coupons_by_brand'
    #   end
    # end

    get 'coupon_counts_by_brand', to: 'grocers#coupon_counts_by_brand'
    get 'active_coupons_over_time', to: 'grocers#active_coupons_over_time'

    # resources :products do
      
    # end

    # resources :stores do
    #   collection do
    #     get 'total_savings', to: 'stores#total_savings'
    #   end
    # end

    # resources :session, only: [:create, :destroy]
    post '/session', to: 'session#create'
    delete '/session', to: 'session#destroy'
  end

  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
end
