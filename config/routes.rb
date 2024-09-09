Rails.application.routes.draw do
  resources :orders, only: [:create, :index]
  patch 'orders/:reference/mark_as_ready', to: 'orders#mark_as_ready' 
end
