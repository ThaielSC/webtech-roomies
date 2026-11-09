class PropertiesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  before_action :set_property,
                only: [:show, :edit, :update, :destroy]

  before_action :load_form_options,
                only: [:new, :create, :edit, :update]

  def index
    @properties = policy_scope(Property)
                    .includes(:neighborhood, :user)

    authorize Property
  end

  def show
    authorize @property

    @listings = policy_scope(@property.listings)

    @reviewable_visits = if current_user
                           Visit.completed
                                .joins(application: :listing)
                                .where(
                                  listings: { property_id: @property.id },
                                  applications: { user_id: current_user.id }
                                )
                                .left_joins(:review)
                                .where(reviews: { id: nil })
                         else
                           Visit.none
                         end
  end

  def new
    @property = Property.new
    authorize @property
  end

  def create
    @property = Property.new(property_params)
    authorize @property

    @property.user = current_user

    if @property.save
      redirect_to @property, notice: "Property created successfully."
    else
      flash.now[:alert] = "Could not create property."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @property
  end

  def update
    authorize @property

    if @property.update(property_params)
      redirect_to @property, notice: "Property updated successfully."
    else
      flash.now[:alert] = "Could not update property."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @property

    if @property.destroy
      redirect_to properties_path,
                  notice: "Property deleted successfully.",
                  status: :see_other
    else
      redirect_to @property,
                  alert: @property.errors.full_messages.to_sentence
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def load_form_options
    @neighborhoods = Neighborhood.order(:name)
    @amenities = Amenity.order(:name)
  end

  def property_params
    params.require(:property).permit(
      :neighborhood_id,
      :address,
      :property_type,
      :bedrooms_count,
      :bathrooms_count,
      :shared_spaces,
      amenity_ids: []
    )
  end
end