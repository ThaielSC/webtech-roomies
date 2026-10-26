class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Application.includes(:user, listing: :property)
                               .order(created_at: :desc)
  end

  def show
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @application = @listing.applications.build
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @application = @listing.applications.build(application_params)

    # Temporary until the acting-user selector is implemented.
    @application.user = User.find_by(id: params[:user_id]) || User.first

    if @application.save
      redirect_to @listing, notice: "Application submitted successfully."
    else
      flash.now[:alert] = "Could not submit application."
      render "listings/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @application.update(application_params)
      redirect_to @application, notice: "Application updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @application.update(status: :withdrawn)

    redirect_to applications_path,
                notice: "Application withdrawn successfully.",
                status: :see_other
  end

  private

  def set_application
    @application = Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(
      :message,
      :move_in_date,
      :intended_stay_months
    )
  end
end