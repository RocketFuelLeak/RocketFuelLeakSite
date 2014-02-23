RocketFuelLeakSite::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'pages#index'

  get 'epgp' => 'pages#epgp'
  get 'mumble' => 'pages#mumble'
  get 'about' => 'pages#about'
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'

  resources :users
  resources :news, controller: 'posts', as: :posts do
    collection do
      get 'feed' => 'posts#feed', defaults: { format: 'atom' }
    end
  end
  resources :addons
end
