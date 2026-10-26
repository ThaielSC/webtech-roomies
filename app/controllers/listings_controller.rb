class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :load_properties, only: [:new, :create, :edit, :update]

  def index
    @listings = Listing.includes(property: :neighborhood).all
  end

  def show
  end

  def new
    @listing = Listing.new(property_id: params[:property_id])
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.status = :draft

    if @listing.save
      redirect_to @listing, notice: "Listing created successfully."
    else
      flash.now[:alert] = "Could not create listing."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Listing updated successfully."
    else
      flash.now[:alert] = "Could not update listing."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @listing.destroy
      redirect_to listings_path,
                  notice: "Listing deleted successfully.",
                  status: :see_other
    else
      redirect_to @listing,
                  alert: @listing.errors.full_messages.to_sentence
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def load_properties
    @properties = Property.includes(:neighborhood).order(:address)
  end

  def listing_params
    params.require(:listing).permit(
      :property_id,
      :title,
      :monthly_rent,
      :deposit,
      :available_date,
      :minimum_stay_months,
      :is_furnished,
      :has_private_bathroom,
      :description,
      :house_rules,
      photos: []
    )
  end
end