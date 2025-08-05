require "test_helper"

class ProfileUpdaterJobTest < ActiveJob::TestCase
  test "updates profiles" do
    profile = profiles(:one)
    assert_not profile.github_username.nil?

    ProfileUpdaterJob.perform_now([ profile.id ])

    profile.reload
    assert_not profile.github_username.nil?
    assert_not profile.github_url.nil?
  end

  test "handles empty profiles list" do
    assert_nothing_raised do
      ProfileUpdaterJob.perform_now([])
    end
  end

  test "handles non-existent profile" do
    assert_nothing_raised do
      ProfileUpdaterJob.perform_now([ 9999 ])
    end
  end
end
