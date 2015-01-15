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
  resources :arrears, only: [:index]
  resources :clients
  resources :client_payments, only: [:show]
  resources :guides, only: [:index, :show, :edit, :update]
  resources :payments
  resources :properties, path: 'accounts'
  resources :invoicings
  resources :invoice_texts, only: [:index, :show, :edit, :update]
  resources :invoices, only: [:show]
  resources :prints, only: [:show]
  resources :runs, only: [:show]
  resources :single_prints, only: [:show]

  # Admin
  resources :cycles
  resources :users
end
