class NeighborhoodsController < ApplicationController
  before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]

  def index
    @neighborhoods = Neighborhood.order(:name)
  end

  def show
    @listings = @neighborhood.listings.merge(Listing.visible_to(current_user))
  end

  def new
    @neighborhood = Neighborhood.new
  end

  def create
    @neighborhood = Neighborhood.new(neighborhood_params)

    if @neighborhood.save
      redirect_to @neighborhood, notice: "Neighborhood created successfully."
    else
      flash.now[:alert] = "Could not create neighborhood."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @neighborhood.update(neighborhood_params)
      redirect_to @neighborhood, notice: "Neighborhood updated successfully."
    else
      flash.now[:alert] = "Could not update neighborhood."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @neighborhood.destroy
      redirect_to neighborhoods_path, notice: "Neighborhood deleted successfully."
    else
      redirect_to @neighborhood, alert: @neighborhood.errors.full_messages.to_sentence
    end
  end

  private

  def set_neighborhood
    @neighborhood = Neighborhood.find(params[:id])
  end

  def neighborhood_params
    params.require(:neighborhood).permit(:name)
  end
end