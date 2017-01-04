Rails.application.routes.draw do
  resources :requests, only: [:create]
  namespace :admin do
    resources :users
    root to: 'users#index'
  end
  root to: 'visitors#index'
  devise_for :users, controllers: { registrations: 'registrations',
                                    omniauth_callbacks: 'omniauth_callbacks'}
  resources :users
end
