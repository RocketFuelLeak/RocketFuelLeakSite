RocketFuelLeakSite::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'pages#index'

  get 'epgp' => 'pages#epgp'
  get 'mumble' => 'pages#mumble'
  get 'about' => 'pages#about'
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'

  resources :users, except: [:new, :create] do
    member do
      patch 'toggle_role/:role' => 'users#toggle_role', as: :toggle_role
      patch 'toggle_member' => 'users#toggle_member'
      patch 'toggle_officer' => 'users#toggle_officer'
      patch 'toggle_admin' => 'users#toggle_admin'
    end
  end

  resources :characters, except: [:new, :create] do
    collection do
      get 'connection' => 'characters#connection'
      post 'connect' => 'characters#connect'
    end

    member do
      get 'confirmation' => 'characters#confirmation'
      patch 'confirm' => 'characters#confirm'
      patch 'toggle_confirmed' => 'characters#toggle_confirmed'
    end
  end

  resources :news, controller: 'posts', as: :posts do
    collection do
      get 'archive/:year/:month' => 'posts#archive', constraints: { year: /\d{4}/, month: /\d{2}/ }, as: :archive
      get 'feed' => 'posts#feed', defaults: { format: 'atom' }
    end
  end
  resources :addons
end
