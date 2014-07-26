Letting::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'
  resources :users do
    collection do
      get :search
    end
  end
  resources :sessions, only: [:create, :destroy] do
    collection do
      get :search
    end
  end

  root 'properties#index'
  resources :properties do
    collection do
      get :search
    end
  end
  resources :search_suggestions, only: [:index]
  resources :clients do
    collection do
      get :search
    end
  end

  resources :charges
  resources :debit_generators, only: [:new, :create, :index] do
    collection do
      get :search
    end
  end
  resources :payments,
            only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
    end
  end
  resources :invoices, only: [:index, :show]
  resources :sheets do
    collection do
      get :search
    end
  end
end
