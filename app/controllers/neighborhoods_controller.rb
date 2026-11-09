class NeighborhoodsController < ApplicationController
  before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]

  allow_unauthenticated_access only: [:index, :show]

  def index
    authorize Neighborhood
    @neighborhoods = policy_scope(Neighborhood).order(:name)
  end

  def show
    authorize @neighborhood

    @listings = policy_scope(@neighborhood.listings)
  end

  def new
    @neighborhood = Neighborhood.new
    authorize @neighborhood
  end

  def create
    @neighborhood = Neighborhood.new(neighborhood_params)
    authorize @neighborhood

    if @neighborhood.save
      redirect_to @neighborhood, notice: "Neighborhood created successfully."
    else
      flash.now[:alert] = "Could not create neighborhood."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @neighborhood
  end

  def update
    authorize @neighborhood

    if @neighborhood.update(neighborhood_params)
      redirect_to @neighborhood, notice: "Neighborhood updated successfully."
    else
      flash.now[:alert] = "Could not update neighborhood."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @neighborhood

    if @neighborhood.destroy
      redirect_to neighborhoods_path,
                  notice: "Neighborhood deleted successfully."
    else
      redirect_to @neighborhood,
                  alert: @neighborhood.errors.full_messages.to_sentence
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
