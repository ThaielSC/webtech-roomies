Rails.application.routes.draw do
  root "home#index"
  patch "current_user", to: "application#switch_user", as: :current_user

  resources :neighborhoods
  resources :amenities
  resources :properties

  resources :listings do
    resources :applications, only: [:create]
    member do
      patch :publish
      patch :withdraw
      patch :mark_rented
    end
  end

  resources :applications, only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch :shortlist
      patch :reject
      patch :accept
    end
  end

  resources :visits do
    member do
      patch :confirm
      patch :cancel
      patch :complete
    end
  end
  resources :reviews
end