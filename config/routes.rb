Rails.application.routes.draw do
  resources :calls
  resources :requests, only: [:create]
  namespace :admin do
    resources :users
    resources :calls
    resources :identities
    resources :requests
    resources :products
    resources :countries
    root to: 'calls#index'
  end
  root to: 'visitors#index'
  devise_for :users, controllers: { registrations: 'user/registrations',
                                    sessions: 'user/sessions',
                                    omniauth_callbacks: 'omniauth_callbacks'}

  resources :users do
    post :bulk, to: 'users#bulk', on: :collection
    get :autocomplete, on: :collection
  end
end
