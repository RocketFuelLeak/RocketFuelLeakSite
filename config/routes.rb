RocketFuelLeakSite::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  root 'pages#index'

  get 'rules' => 'pages#rules'
  get 'epgp' => 'pages#epgp'
  get 'mumble' => 'pages#mumble'
  get 'about' => 'pages#about'
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'

  namespace :forums, module: :forum, as: :forum do
    resources :categories, path: '/', only: [:index, :create]

    resources :categories, except: [:index, :create] do
      resources :forums, only: [:index, :new, :create] do
        resources :topics, only: [:index, :new, :create] do
          resources :posts, only: [:index, :new, :create]
        end
      end
    end

    resources :forums, path: '/', only: [:show, :edit, :update, :destroy]
    resources :topics, only: [:show, :edit, :update, :destroy]
    resources :posts, only: [:show, :edit, :update, :destroy]
  end

  resources :addons

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
      get 'connect' => 'characters#connect'
      post 'connect' => 'characters#post_connect'
    end

    member do
      get 'confirm' => 'characters#confirm'
      patch 'confirm' => 'characters#patch_confirm'
      patch 'toggle_confirmed' => 'characters#toggle_confirmed'
    end
  end

  resources :news, controller: 'posts', as: :posts do
    collection do
      get 'archive/:year/:month' => 'posts#archive', constraints: { year: /\d{4}/, month: /\d{2}/ }, as: :archive
      get 'feed' => 'posts#feed', defaults: { format: 'atom' }
    end

    resources :comments
  end

  resources :applications do
    member do
      patch 'open' => 'applications#open'
      patch 'accept' => 'applications#accept'
      patch 'decline' => 'applications#decline'
    end

    resources :comments
  end
end
