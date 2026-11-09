class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :review, :dismiss, :take_action]

  def index
    authorize Report
    @reports = policy_scope(Report)
                 .includes(:user, :listing)
                 .order(created_at: :desc)
  end

  def show
    authorize @report
  end

  def new
    @listing = Listing.find(params[:listing_id])
    authorize @listing, :show?

    @report = Report.new(listing: @listing)
    authorize @report
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user
    @report.status = :pending

    authorize @report

    unless @report.listing && policy(@report.listing).show?
      raise Pundit::NotAuthorizedError
    end

    if @report.save
      redirect_to @report.listing,
                  notice: "Your report has been submitted."
    else
      @listing = @report.listing
      flash.now[:alert] = "Could not submit report."
      render :new, status: :unprocessable_entity
    end
  end

  def review
    authorize @report, :review?
    change_status!(:reviewed)
  end

  def dismiss
    authorize @report, :dismiss?
    change_status!(:dismissed)
  end

  def take_action
    authorize @report, :take_action?
    change_status!(:action_taken)
  end

  private

  def set_report
    @report = policy_scope(Report).find(params[:id])
  end

  def report_params
    params.require(:report).permit(:listing_id, :reason_category, :details)
  end

  def change_status!(status)
    @report.update!(status: status)
    redirect_to report_path(@report),
                notice: "Report marked as #{status.to_s.humanize.downcase}."
  end
end
