class HomeController < ApplicationController
  def index
    @featured_listings = Listing.published.limit(3)
  end
end