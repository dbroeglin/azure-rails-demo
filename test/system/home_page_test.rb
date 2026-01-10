require "application_system_test_case"

class HomePageTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_path
    
    assert_selector "h1", text: "Welcome"
  end

  test "home page is accessible without authentication" do
    visit root_path
    
    assert_response :success
    assert_current_path root_path
  end

  test "home page shows sign in link when not authenticated" do
    visit root_path
    
    assert_link "Sign in"
  end
end
