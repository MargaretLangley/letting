Letting::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'

  resources :users
  resources :sessions, only: [:create, :destroy]

  get 'search' => 'search#index', as: :search

  root 'properties#index'
  resources :properties
  resources :search_suggestions, only: [:index]
  resources :clients

  resources :charges
  resources :debit_generators, only: [:new, :create, :index]

  resources :charge_cycles do
    collection do
      get 'newmonth'
    end
  end

  resources :payments
  resources :invoices, only: [:index, :show]
  resources :sheets
end
