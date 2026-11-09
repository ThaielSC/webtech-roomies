class ApplicationsController < ApplicationController
  before_action :set_application, only: [
    :show, :edit, :update, :destroy, :shortlist, :reject, :accept
  ]

  def index
    authorize Application

    @applications = policy_scope(Application)
      .includes(:user, listing: :property)
      .order(created_at: :desc)

    @pending_count = host_application_scope.pending.count
  end

  def show
    authorize @application
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @application = @listing.applications.build

    authorize @application
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @application = @listing.applications.build(application_params)
    @application.user = current_user

    authorize @application

    if @application.save
      respond_to do |format|
        format.html {
          redirect_to @listing,
                      notice: "Application submitted successfully."
        }

        format.turbo_stream
      end
    else
      @listing = @application.listing

      respond_to do |format|
        format.html {
          flash.now[:alert] = "Could not submit application."
          render "listings/show", status: :unprocessable_entity
        }

        format.turbo_stream {
          render "create_error", status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    authorize @application
  end

  def update
    authorize @application

    if @application.update(application_params)
      redirect_to @application,
                  notice: "Application updated successfully."
    else
      flash.now[:alert] = "Could not update application."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @application

    @application.withdraw!(actor: current_user)

    redirect_to @application.listing,
                notice: "Application withdrawn successfully.",
                status: :see_other

  rescue ActiveRecord::RecordNotSaved,
         ActiveRecord::RecordInvalid => error

    redirect_to @application, alert: error.message
  end

  def shortlist
    authorize @application, :shortlist?

    @application.shortlist!
    respond_to_status_change("Application shortlisted.")

  rescue ActiveRecord::RecordNotSaved,
         ActiveRecord::RecordInvalid => error

    redirect_to applications_path, alert: error.message
  end

  def reject
    authorize @application, :reject?

    @application.reject!
    respond_to_status_change("Application rejected.")

  rescue ActiveRecord::RecordNotSaved,
         ActiveRecord::RecordInvalid => error

    redirect_to applications_path, alert: error.message
  end

  def accept
    authorize @application, :accept?

    @application.accept!
    respond_to_status_change("Application accepted; listing reserved.")

  rescue ActiveRecord::RecordNotSaved,
         ActiveRecord::RecordInvalid => error

    redirect_to applications_path, alert: error.message
  end

  private

  def set_application
    @application = policy_scope(Application).find(params[:id])
  end

  def host_application_scope
    Application.joins(listing: :property)
      .where(properties: { user_id: current_user&.id })
  end

  def application_params
    params.require(:application)
      .permit(:message, :move_in_date, :intended_stay_months)
  end

  def respond_to_status_change(message)
    respond_to do |format|
      format.html {
        redirect_to applications_path, notice: message
      }

      format.turbo_stream do
        @applications = Application.where(
          listing_id: @application.listing_id
        )

        @pending_count = host_application_scope.pending.count

        flash.now[:notice] = message

        render :status_change
      end
    end
  end
end
