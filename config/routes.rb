Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get "pricing", to: "static_pages#pricing"
  resources :posts
  post "checkout/create", to: "checkout#create", as: "checkout_create"
  post "billing_portal/create", to: "billing_portal#create", as: "billing_portal_create"
  resources :webhooks, only: [:create]
end
