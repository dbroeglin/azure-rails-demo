require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "shows index page without authentication" do
    get root_path
    assert_response :success
  end

  test "shows index page when authenticated" do
    sign_in_as(users(:one))
    get root_path
    assert_response :success
  end
end
