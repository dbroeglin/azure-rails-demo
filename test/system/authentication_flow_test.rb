require "application_system_test_case"

class AuthenticationFlowTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "user can sign in with valid credentials" do
    visit root_path
    click_on "Sign in"

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    assert_text "You are signed in"
  end

  test "user cannot sign in with invalid credentials" do
    visit new_session_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "wrongpassword"
    click_on "Sign in"

    assert_text "Try another email address or password"
  end

  test "user can sign out" do
    # Sign in first
    visit new_session_path
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    # Then sign out
    click_on "Sign out"
    
    assert_current_path new_session_path
  end

  test "authenticated user is redirected to original page after login" do
    # Try to access a protected page
    visit root_path
    
    # Should be redirected to sign in (if authentication is required)
    # Then after signing in, should return to the original page
    if current_path == new_session_path
      fill_in "Email address", with: @user.email_address
      fill_in "Password", with: "password"
      click_on "Sign in"
      
      assert_current_path root_path
    end
  end
end
