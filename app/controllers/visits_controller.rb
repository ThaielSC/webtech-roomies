class VisitsController < ApplicationController
  before_action :set_visit, only: [
    :show, :edit, :update, :destroy,
    :confirm, :cancel, :complete
  ]

  before_action :load_applications, only: [:new, :create, :edit, :update]

  def index
    @visits = Visit.includes(application: [:user, :listing])
                   .order(date_time: :desc)
  end

  def show
  end

  def new
    @visit = Visit.new(application_id: params[:application_id])
  end

  def create
    @visit = Visit.new(visit_params)
    @visit.application = @applications.find { |application| application.id == @visit.application_id }
    @visit.status = :proposed

    if @visit.save
      redirect_to @visit, notice: "Visit proposed successfully."
    else
      flash.now[:alert] = "Could not propose visit."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @visit.update(visit_update_params)
      redirect_to @visit, notice: "Visit updated successfully."
    else
      flash.now[:alert] = "Could not update visit."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @visit.destroy
      redirect_to visits_path,
                  notice: "Visit deleted successfully.",
                  status: :see_other
    else
      redirect_to @visit,
                  alert: @visit.errors.full_messages.to_sentence
    end
  end

  def confirm
    change_status(:confirmed, "Visit confirmed successfully.")
  end

  def cancel
    change_status(:cancelled, "Visit cancelled successfully.")
  end

  def complete
    change_status(:completed, "Visit completed successfully.")
  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
  end

  def load_applications
    @applications = Application.shortlisted.joins(listing: :property).includes(:user, :listing)
                               .where(properties: { user_id: current_user&.id })
                               .order(created_at: :desc).to_a
    if @visit&.application && @visit.application.listing.property.user_id == current_user&.id
      @applications << @visit.application unless @applications.include?(@visit.application)
    end
  end

  def visit_params
    params.require(:visit).permit(
      :application_id,
      :date_time,
      :notes
    )
  end

  def visit_update_params
    params.require(:visit).permit(:date_time, :notes)
  end

  def change_status(status, message)
    if @visit.update(status: status)
      redirect_to @visit, notice: message
    else
      redirect_to @visit,
                  alert: @visit.errors.full_messages.to_sentence
    end
  end
end