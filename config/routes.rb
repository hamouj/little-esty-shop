Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # Admin dashboard route
  resources :admin, only: :index

  # Admin/merchants and admin/invoices routes
  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :new, :create]
		resources :invoices, only: [:index, :show]
  end

  patch '/admin/merchants/:id', to: 'admin/merchants#update'
  patch '/admin/invoices/:id', to: 'admin/invoices#update'

  # Merchants, merchant/items, merchant/invoices, merchant/bulk_discounts

	resources :merchants, only: [:index, :show] do
		resources :items, except: :update, controller: 'merchant/items'
    resources :invoices, only: [:index, :show], controller: 'merchant/invoices'
    resources :bulk_discounts, except: :update, controller: 'merchant/bulk_discounts'
	end

  get '/merchants/:id/dashboard', to: "merchants#show"

  patch '/merchants/:merchant_id/invoices/:id', to: 'merchant/invoice_items#update'
	patch '/merchants/:merchant_id/items/:id', to: "merchant/items#update"
  patch '/merchants/:merchant_id/bulk_discounts/:id', to: "merchant/bulk_discounts#update"
end
