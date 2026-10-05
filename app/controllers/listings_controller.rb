class ListingsController < ApplicationController
  def index
    @listings = Listing.published
  end

  def show
    @listing = Listing.find(params[:id])
  end
end