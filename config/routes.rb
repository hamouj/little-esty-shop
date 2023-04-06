Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :admin, only: :index

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
		resources :invoices, only: [:index, :show]
  end

	resources :merchants, only: [:index, :show] do
		resources :items, except: :update, controller: 'merchant/items'
    resources :invoices, only: [:index, :show], controller: 'merchant/invoices'
	end

  patch '/merchants/:merchant_id/invoices/:id', to: 'merchant/invoice_items#update'

  get '/merchants/:id/dashboard', to: "merchants#show"
	patch '/merchants/:merchant_id/items/:id', to: "merchant/items#update"

  patch '/admin/merchants/:id', to: "admin/merchants#update"
  patch '/admin/invoices/:id', to: "admin/invoices#update"
end
