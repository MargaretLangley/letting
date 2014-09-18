Letting::Application.routes.draw do

  resources :sessions, only: [:create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'

  get 'search' => 'search#index', as: :search
  # TODO: name change to autocomplete?
  resources :search_suggestions, only: [:index]

  root 'properties#index'
  resources :properties
  resources :clients
  # TODO: do we need debit_generators?
  resources :debit_generators, only: [:new, :create, :index]
  resources :payments
  resources :invoicings, only: [:new, :create, :index]

  # Admin
  resources :charge_cycles
  resources :users
  resources :sheets, only: [:index, :show, :edit, :update]
end
