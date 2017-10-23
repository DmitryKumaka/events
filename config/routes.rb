Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'events#index'
  resources :events
  get 'events/:id/users', to: 'events#users', as: :users
  put 'events/:id/update_users', to: 'events#update_users', as: :update_users
end
