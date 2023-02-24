Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :merchants, only: [:show] do
  #   resources :dashboard, only: [:index]
  # end
  
  
  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update]
		resources :invoices, only: [:index, :show]
  end
  get '/merchants/:id/dashboard', to: "merchants#show"
  get '/merchants/:id/items', to: "items#index"
  get '/merchants/:id/invoices', to: "invoices#index"
  resources :admin, only: :index

end
