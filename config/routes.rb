Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homes#top'
  get 'homes/about' => 'homes#about', as: 'about'
  
  resources :recipes
  
  resources :users, only:[:index, :show, :edit, :update]
  get 'users/:id/quit' => 'users#quit', as: 'quit'
  patch 'users/:id/out' => 'users#out', as: 'out'
  
end
