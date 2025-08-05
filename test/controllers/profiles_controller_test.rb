require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { name: "Test Name", github_url: "https://github.com/newone" } }
    end
    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { name: "Updated Name", bio: "Updated Bio" } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@profile)
    end
    assert_redirected_to profiles_url
  end

  test "seach profiles by name" do
    get search_profiles_url, params: { q: @profile.name }
    assert_response :success
    assert_select "h5", text: @profile.name
  end

  test "search profiles by non-existent name" do
    get search_profiles_url, params: { q: "blabla" }
    assert_response :success
    assert_select "h4", text: "Nenhum perfil encontrado"
  end

  test "open profile by short code" do
    get short_profile_url(short_code: @profile.short_url)
    assert_redirected_to "#{ENV['APP_URL']}/profiles/#{@profile.id}"
  end

  test "open profile by invalid short code" do
    get short_profile_url(short_code: "invalidcode")
    assert_redirected_to profiles_path
    assert_equal "Perfil não encontrado!", flash[:alert]
  end
end
