Letting::Application.routes.draw do

  get 'arrears/index'

  resources :sessions, only: [:create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'

  get 'search' => 'search#index', as: :search

  resources :search_suggestions, only: [:index]

  root 'properties#index'
  resources :properties
  resources :arrears, only: [:index]
  resources :clients
  resources :payments
  resources :invoicings
  resources :invoices, only: [:show]
  resources :prints, only: [:show]
  resources :prints_screens, only: [:show]
  resources :single_prints, only: [:show]
  resources :templates, only: [:index, :show, :edit, :update]
  resources :guides, only: [:index, :show, :edit, :update]

  # Admin
  resources :cycles
  resources :users
end
