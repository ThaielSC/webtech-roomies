Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "registrations/new"
  # Authentication
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]

  resource :registration, only: [:new, :create]
  resource :profile, only: [:show, :edit, :update]

  # Public landing page
  root "home#index"

  # Neighborhoods and amenities
  resources :neighborhoods
  resources :amenities

  # Properties
  resources :properties

  # Listings
  resources :listings do
    resources :applications, only: [:create]

    member do
      patch :publish
      patch :withdraw
      patch :mark_rented
    end
  end

  # Applications
  resources :applications, only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch :shortlist
      patch :reject
      patch :accept
    end
  end

  # Visits
  resources :visits do
    member do
      patch :confirm
      patch :cancel
      patch :complete
    end
  end

  # Reports
  resources :reports, only: [:index, :new, :create, :show] do
    member do
      patch :review
      patch :dismiss
      patch :take_action
    end
  end

  # Reviews
  resources :reviews
end