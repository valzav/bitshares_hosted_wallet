Rails.application.routes.draw do

  root 'welcome#index'
  devise_for :users

  namespace :admin do
    resources :coupons
  end

  get '/app' => 'bts#app', as: 'app'
  match '/rpc' => 'bts#rpc', via: [:post]

  namespace :api do
    namespace :v1 do
      resources :coupons do
        get 'redeem'
      end
    end
  end

end
