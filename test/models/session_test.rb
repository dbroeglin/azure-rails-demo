require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "belongs to user" do
    session = Session.new
    assert_respond_to session, :user
  end

  test "requires user" do
    session = Session.new
    assert_not session.valid?
    assert_includes session.errors[:user], "must exist"
  end

  test "creates session with user_agent and ip_address" do
    user = users(:one)
    session = user.sessions.create!(user_agent: "Mozilla/5.0", ip_address: "192.168.1.1")
    
    assert session.persisted?
    assert_equal "Mozilla/5.0", session.user_agent
    assert_equal "192.168.1.1", session.ip_address
    assert_equal user, session.user
  end

  test "can create multiple sessions for same user" do
    user = users(:one)
    
    assert_difference "user.sessions.count", 2 do
      user.sessions.create!
      user.sessions.create!(user_agent: "Chrome", ip_address: "10.0.0.1")
    end
  end

  test "has created_at and updated_at timestamps" do
    user = users(:one)
    session = user.sessions.create!
    
    assert_not_nil session.created_at
    assert_not_nil session.updated_at
  end
end
