require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  def setup
    @profile = profiles(:one)
  end

  test "should be valid with valid attributes" do
    assert @profile.valid?
  end

  test "should require github_url" do
    @profile.github_url = nil
    assert @profile.valid?
  end

  test "should require github_username" do
    profile = Profile.new
    assert_not profile.valid?
    assert_includes profile.errors[:github_username], "can't be blank"
  end

  test "should enforce uniqueness of github_url" do
    duplicate = @profile.dup
    duplicate.github_username = "anotheruser"
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:github_url], "has already been taken"
  end

  test "should enforce uniqueness of github_username" do
    duplicate = @profile.dup
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:github_username], "has already been taken"
  end

  test "should validate github_url format (full url)" do
    @profile.github_url = "https://github.com/validuser"
    assert @profile.valid?
  end

  test "should validate github_url format (username only)" do
    @profile.github_url = "validuser"
    assert @profile.valid?
  end

  test "should not accept invalid github_url format" do
    @profile.github_url = "https://notgithub.com/invalid"
    assert_not @profile.valid?
    assert_includes @profile.errors[:github_url], "must be a valid GitHub URL or just the username"
  end

  test "extract_username sets github_username from github_url (full url)" do
    profile = Profile.new(github_url: "https://github.com/testuser")
    profile.valid?
    assert_equal "testuser", profile.github_username
  end

  test "extract_username sets github_username from github_url (username only)" do
    profile = Profile.new(github_url: "testuser")
    profile.valid?
    assert_equal "testuser", profile.github_username
  end

  test "generate_short_url sets short_url before create" do
    profile = Profile.new(github_username: "specialuser")
    profile.save!
    url = "#{ENV['APP_URL']}/profiles/#{profile.id}"
    assert_equal UrlShortenerService.expand_url(profile.short_url), url
  end

  test "search scope finds by name" do
    results = Profile.search(@profile.name)
    assert_includes results, @profile
  end

  test "search scope finds by github_username" do
    results = Profile.search(@profile.github_username)
    assert_includes results, @profile
  end

  test "search scope finds by organization" do
    results = Profile.search(@profile.organization)
    assert_includes results, @profile
  end

  test "search scope finds by location" do
    results = Profile.search(@profile.location)
    assert_includes results, @profile
  end

  test "update_github_data! updates profile attributes" do
    mock_scraped = OpenStruct.new(
      name: "New Name",
      avatar: "http://avatar.url",
      nickname: "newnickname",
      followers: 100,
      following: 50,
      stars: 10,
      contributions: 200,
      organization: "NewOrg",
      location: "NewLocation"
    )
    GithubService::Scrapper.stub :new, OpenStruct.new(profile: mock_scraped) do
      @profile.update_github_data!
      assert_equal "http://avatar.url", @profile.avatar
      assert_equal "newnickname", @profile.github_username
      assert_equal "#{GithubService::Scrapper::GITHUB_BASE_URL}newnickname", @profile.github_url
      assert_equal 100, @profile.followers
      assert_equal 50, @profile.following
      assert_equal 10, @profile.stars
      assert_equal 200, @profile.contributions
      assert_equal "NewOrg", @profile.organization
      assert_equal "NewLocation", @profile.location
    end
  end
end
