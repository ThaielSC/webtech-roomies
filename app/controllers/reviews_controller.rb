class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :load_completed_visits, only: [:new, :create]

  def index
    @reviews = Review.includes(:user, :property, :visit)
                     .order(created_at: :desc)
  end

  def show
  end

  def new
    @review = Review.new(visit_id: params[:visit_id])
  end

  def create
    @review = Review.new(review_params)

    if @review.visit.present?
      @review.user = current_user
      @review.property = @review.visit.application.listing.property
    end

    if @review.save
      redirect_to @review, notice: "Review submitted successfully."
    else
      flash.now[:alert] = "Could not submit review."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_update_params)
      redirect_to @review, notice: "Review updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!

    redirect_to reviews_path,
                notice: "Review deleted successfully.",
                status: :see_other
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def load_completed_visits
    @visits = Visit.completed
                   .includes(application: [:user, { listing: :property }])
                   .where(applications: { user_id: current_user&.id })
                   .order(date_time: :desc)
  end

  def review_params
    params.require(:review).permit(
      :visit_id,
      :rating,
      :comment
    )
  end

  def review_update_params
    params.require(:review).permit(
      :rating,
      :comment
    )
  end
end