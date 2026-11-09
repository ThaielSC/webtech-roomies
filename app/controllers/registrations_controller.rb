class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: "Welcome to Roomies!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email_address,
      :phone_number,
      :password,
      :password_confirmation
    )
  end
end