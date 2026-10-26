class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  before_action :load_form_options, only: [:new, :create, :edit, :update]

  def index
    @properties = Property.includes(:neighborhood, :user).all
  end

  def show
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      redirect_to @property, notice: "Property created successfully."
    else
      flash.now[:alert] = "Could not create property."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: "Property updated successfully."
    else
      flash.now[:alert] = "Could not update property."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
    @users = User.order(:first_name, :last_name)
  end

  def property_params
    params.require(:property).permit(
      :user_id,
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