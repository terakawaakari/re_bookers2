Rails.application.routes.draw do

  root to: 'homes#top'
  
  devise_scope :user do
    post 'users/guest_sign_in' => 'application#guest_sign_in'
  end

  get 'home/about' => 'homes#about'

  get 'books/search' => 'books#search'

  devise_for :users

  resources :users, :only => [:index, :show, :edit, :update]

  resources :books do
    resources :post_comments, :only => [:create, :destroy]
    resource :favorites, :only => [:create, :destroy]
  end

end
