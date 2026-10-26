Rails.application.routes.draw do
  root "home#index"

  resources :neighborhoods
  resources :amenities
  resources :properties

  resources :listings do
    resources :applications, only: [:create]
  end

  resources :applications, only: [:index, :show, :edit, :update, :destroy]

  resources :visits do
    member do
      patch :confirm
      patch :cancel
      patch :complete
    end
  end
  resources :reviews
end