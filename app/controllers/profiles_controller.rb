class ProfilesController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def profile_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email_address,
      :phone_number,
      :bio
    )
  end
end