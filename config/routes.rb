Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do

    get 'coupon_counts_by_brand', to: 'grocers#coupon_counts_by_brand'
    get 'active_coupons_over_time', to: 'grocers#active_coupons_over_time'
    get 'savings_by_brand', to: 'brands#savings_by_brand'

    post '/session', to: 'session#create'
    delete '/session', to: 'session#destroy'
  end

  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
end
