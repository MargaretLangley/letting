Letting::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'
  resources :users
  resources :sessions, only: [:create, :destroy]

  root 'properties#index'
  resources :properties do
    collection do
      get :search
    end
  end
  resources :search_suggestions, only: [:index]
  resources :clients

  resources :charges
  resources :debit_generators, only: [:new, :create, :index]
  resources :payments, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :invoices, only: [:new]

end
