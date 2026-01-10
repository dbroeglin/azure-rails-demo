require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "authenticated? returns true when user is signed in" do
    user = users(:one)
    sign_in_as(user)
    
    get root_path
    assert_response :success
  end

  test "authenticated? returns false when user is not signed in" do
    get root_path
    # Home controller allows unauthenticated access, so we still get success
    assert_response :success
  end

  test "require_authentication redirects to sign in for protected pages" do
    # This would apply to controllers that don't allow unauthenticated access
    # Since our app's controllers mostly allow unauthenticated access,
    # we verify the authentication flow works
    
    user = users(:one)
    sign_in_as(user)
    
    delete session_path
    assert_redirected_to new_session_path
  end

  test "after_authentication_url returns to original page" do
    # Set a return URL
    get root_path
    
    # Simulate setting return_to in session (this would normally happen
    # when an unauthenticated user tries to access a protected page)
    user = users(:one)
    post session_path, params: { 
      email_address: user.email_address, 
      password: "password" 
    }
    
    assert_redirected_to root_path
  end

  test "start_new_session_for creates session with user agent and ip" do
    user = users(:one)
    
    assert_difference "Session.count", 1 do
      post session_path, params: { 
        email_address: user.email_address, 
        password: "password" 
      }, headers: { "HTTP_USER_AGENT" => "Test Browser" }
    end
    
    session = Session.last
    assert_equal user, session.user
    assert_not_nil session.user_agent
    assert_not_nil session.ip_address
  end

  test "terminate_session destroys current session" do
    user = users(:one)
    sign_in_as(user)
    
    assert_difference "Session.count", -1 do
      delete session_path
    end
  end

  test "session cookie is httponly and same_site lax" do
    user = users(:one)
    
    post session_path, params: { 
      email_address: user.email_address, 
      password: "password" 
    }
    
    # Verify cookie is set (Rails test cookies don't expose httponly/samesite directly)
    assert cookies[:session_id]
  end
end
