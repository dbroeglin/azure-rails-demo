require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @default_url_options = { host: "example.com" }
  end

  test "reset email" do
    user = users(:one)
    email = PasswordsMailer.reset(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["from@example.com"], email.from
    assert_equal [user.email_address], email.to
    assert_equal "Reset your password", email.subject
    # Match the token pattern since it changes each time
    assert_match /passwords\/[A-Za-z0-9_\-]+\/edit/, email.body.encoded
  end

  test "reset email contains reset link" do
    user = users(:one)
    email = PasswordsMailer.reset(user)

    # Check that the email contains a properly formatted reset link
    assert_match /http:\/\/example\.com\/passwords\/[A-Za-z0-9_\-]+\/edit/, email.body.encoded
  end
end
