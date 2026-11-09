class HomeController < ApplicationController
  allow_unauthenticated_access only: [:index]
  def index
    @featured_listings = Listing.published.limit(3)
  end
end