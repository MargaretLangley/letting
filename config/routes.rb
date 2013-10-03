Letting::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: [:new, :create, :destroy]

  resources :search_suggestions

  root 'properties#index'

  resources :blocks, only: [:new, :create, :index]

  resources :properties do
    collection do
      get :search
    end
  end
  resources :clients
  resources :charges
  resources :debts do
    collection do
      put :apply
    end
  end
  resources :payments
  resources :users

  resources :debt_generators
end
