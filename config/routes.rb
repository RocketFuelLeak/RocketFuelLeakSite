RocketFuelLeakSite::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'pages#index'

  get 'epgp' => 'pages#epgp'
  get 'about' => 'pages#about'

  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'

  resources :news, controller: 'posts', as: :posts
  resources :addons
end
