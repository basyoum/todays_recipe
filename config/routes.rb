Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homes#top'
  get 'homes/about' => 'homes#about', as: 'about'
  get 'search' => 'searches#search'
  
  resources :recipes do
    resource :favorites, only:[:create, :destroy]
    resources :recipe_comments, only:[:create, :destroy]
  end
  
  resources :users, only:[:index, :show, :edit, :update] do
    member do
      get :favorites
    end
  end
  get 'users/:id/quit' => 'users#quit', as: 'quit'
  patch 'users/:id/out' => 'users#out', as: 'out'
  
end
