RocketFuelLeakSite::Application.routes.draw do
  devise_for :users

  root 'pages#index'

  get 'epgp' => 'pages#epgp'
  get 'about' => 'pages#about'

  resources :news, controller: 'posts', as: :news
  resources :addons
end
