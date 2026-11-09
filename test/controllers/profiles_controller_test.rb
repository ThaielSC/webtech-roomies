require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "unauthenticated users cannot view profile" do
    get profile_path
    assert_redirected_to new_session_path
  end

  test "unauthenticated users cannot edit profile" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "authenticated users can view profile" do
    sign_in_as(@user)

    get profile_path
    assert_response :success
  end

  test "authenticated users can edit profile" do
    sign_in_as(@user)

    get edit_profile_path
    assert_response :success
  end

  private

  def sign_in_as(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
    assert_redirected_to root_path
  end
end
