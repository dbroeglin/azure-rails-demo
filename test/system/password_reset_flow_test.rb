require "application_system_test_case"

class PasswordResetFlowTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "user can request a password reset" do
    visit root_path
    click_on "Sign in"
    click_on "Forgot password?"

    fill_in "Email address", with: @user.email_address
    click_on "Send reset instructions"

    assert_text "Password reset instructions sent"
  end

  test "user can reset their password with valid token" do
    token = @user.password_reset_token
    
    visit edit_password_path(token)
    
    fill_in "Password", with: "newpassword123"
    fill_in "Password confirmation", with: "newpassword123"
    click_on "Reset password"

    assert_text "Password has been reset"
    
    # Verify user can sign in with new password
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "newpassword123"
    click_on "Sign in"
    
    assert_text "You are signed in"
  end

  test "user cannot reset password with invalid token" do
    visit edit_password_path("invalid_token")
    
    assert_text "Password reset link is invalid"
  end

  test "password reset with mismatched passwords shows error" do
    token = @user.password_reset_token
    
    visit edit_password_path(token)
    
    fill_in "Password", with: "newpassword123"
    fill_in "Password confirmation", with: "differentpassword"
    click_on "Reset password"

    assert_text "Passwords did not match"
  end
end
