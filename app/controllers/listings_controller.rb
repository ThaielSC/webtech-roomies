class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :publish, :withdraw, :mark_rented]
  before_action :ensure_host, only: [:edit, :update, :destroy, :publish, :withdraw, :mark_rented]
  before_action :load_properties, only: [:new, :create, :edit, :update]

  def index
    @listings = Listing.visible_to(current_user).includes(property: :neighborhood)
  end

  def show
    @application = @listing.applications.find_by(user: current_user) || @listing.applications.build
  end

  def new
    @listing = Listing.new(property_id: params[:property_id])
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.status = :draft
    @listing.property = Property.where(user: current_user).find_by(id: @listing.property_id)

    if @listing.save
      redirect_to @listing, notice: "Listing created successfully."
    else
      flash.now[:alert] = "Could not create listing."
      render :new, status: :unprocessable_entity
    end
  end

  def publish
    @listing.publish!
    redirect_to @listing, notice: "Listing published successfully."
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to @listing, alert: error.message
  end

  def withdraw
    @listing.withdraw!
    redirect_to @listing, notice: "Listing withdrawn successfully."
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to @listing, alert: error.message
  end

  def mark_rented
    @listing.mark_rented!
    redirect_to @listing, notice: "Listing marked as rented."
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to @listing, alert: error.message
  end

  def edit
  end

  def update
    attributes = listing_params
    property_id = attributes[:property_id].presence || @listing.property_id
    unless @properties.exists?(id: property_id)
      @listing.errors.add(:property, "must belong to the current host")
      flash.now[:alert] = "Could not update listing."
      return render :edit, status: :unprocessable_entity
    end

    if @listing.update(attributes)
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

  def load_properties
    @properties = Property.where(user: current_user).includes(:neighborhood).order(:address)
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

  def set_listing
    @listing = Listing.visible_to(current_user).find(params[:id])
  end

  def ensure_host
    return if @listing.property.user_id == current_user&.id

    redirect_to @listing, alert: "Only the host can manage this listing."
  end
end
