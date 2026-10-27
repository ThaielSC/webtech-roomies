class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy, :shortlist, :reject, :accept]

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

    @application.user = current_user

    if @application.save
      respond_to do |format|
        format.html { redirect_to @listing, notice: "Application submitted successfully." }
        format.turbo_stream
      end
    else
      @listing = @application.listing
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Could not submit application."
          render "listings/show", status: :unprocessable_entity
        end
        format.turbo_stream { render "create_error", status: :unprocessable_entity }
      end
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
    @application.withdraw!(actor: current_user)

    redirect_to applications_path,
                notice: "Application withdrawn successfully.",
                status: :see_other
  end

  def shortlist
    @application.shortlist!
    respond_to_status_change("Application shortlisted.")
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to applications_path, alert: error.message
  end

  def reject
    @application.reject!
    respond_to_status_change("Application rejected.")
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to applications_path, alert: error.message
  end

  def accept
    @application.accept!
    respond_to_status_change("Application accepted; listing reserved.")
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => error
    redirect_to applications_path, alert: error.message
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

  def respond_to_status_change(message)
    respond_to do |format|
      format.html { redirect_to applications_path, notice: message }
      format.turbo_stream do
        @applications = Application.where(listing_id: @application.listing_id)
        flash.now[:notice] = message
        render :status_change
      end
    end
  end
end
