Rails.application.routes.draw do

  root 'welcome#index'
  get '/home', to: 'welcome#home'
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :sign_out
  end

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
