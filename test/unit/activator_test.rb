require 'test_helper'

class ActivatorTest < ActionMailer::TestCase
  test "signup_token" do
    @expected.subject = 'Activator#signup_token'
    @expected.body    = read_fixture('signup_token')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Activator.create_signup_token(@expected.date).encoded
  end

end
