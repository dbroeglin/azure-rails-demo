require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires email_address" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires unique email_address" do
    existing_user = users(:one)
    user = User.new(email_address: existing_user.email_address, password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "requires password" do
    user = User.new(email_address: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "authenticates with valid credentials" do
    user = users(:one)
    authenticated_user = User.authenticate_by(email_address: user.email_address, password: "password")
    assert_equal user, authenticated_user
  end

  test "does not authenticate with invalid password" do
    user = users(:one)
    authenticated_user = User.authenticate_by(email_address: user.email_address, password: "wrong")
    assert_nil authenticated_user
  end

  test "does not authenticate with invalid email" do
    authenticated_user = User.authenticate_by(email_address: "nonexistent@example.com", password: "password")
    assert_nil authenticated_user
  end

  test "has many sessions" do
    user = users(:one)
    assert_respond_to user, :sessions
  end

  test "destroys dependent sessions when user is destroyed" do
    user = users(:one)
    user.sessions.create!
    
    assert_difference "Session.count", -1 do
      user.destroy
    end
  end

  test "generates password_reset_token" do
    user = users(:one)
    token = user.password_reset_token
    assert_not_nil token
    assert_kind_of String, token
  end

  test "finds user by valid password_reset_token" do
    user = users(:one)
    token = user.password_reset_token
    found_user = User.find_by_password_reset_token!(token)
    assert_equal user, found_user
  end

  test "raises error for invalid password_reset_token" do
    assert_raises(ActiveSupport::MessageVerifier::InvalidSignature) do
      User.find_by_password_reset_token!("invalid_token")
    end
  end
end
