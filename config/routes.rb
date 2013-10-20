Letting::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :users
  resources :sessions, only: [:create, :destroy]

  root 'properties#index'
  resources :properties do
    collection do
      get :search
    end
  end
  resources :blocks, only: [:new, :create, :index]
  resources :search_suggestions
  resources :clients

  resources :charges
  resources :debit_generators, only: [:new, :create, :index]
  resources :payments

end
