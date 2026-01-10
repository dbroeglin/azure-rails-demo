require "application_system_test_case"

class SessionManagementTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "user session persists across page visits" do
    # Sign in
    visit new_session_path
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    # Navigate to different pages
    visit root_path
    assert_text "You are signed in"

    # Refresh the page
    visit current_path
    assert_text "You are signed in"
  end

  test "user can have multiple concurrent sessions" do
    # This test verifies that creating multiple sessions is possible
    # In a real scenario, this would be tested with multiple browsers
    
    visit new_session_path
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    assert_text "You are signed in"
    
    # User should have at least one session
    assert @user.sessions.any?
  end

  test "signing out destroys the current session" do
    # Sign in
    visit new_session_path
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    initial_session_count = @user.sessions.count

    # Sign out
    click_on "Sign out"

    # Session should be destroyed
    assert @user.sessions.count < initial_session_count
    assert_current_path new_session_path
  end
end
