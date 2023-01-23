require "test_helper"
require 'minitest/autorun'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get landing_page" do
    get root_path
    assert_response :success
  end

  test "should get songs by artist" do
    VCR.use_cassette("songs") do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
  end

  test "should get no songs by artist" do
    VCR.use_cassette("no_songs") do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Bogus Artist"}
      assert_response :success
    end
  end

  test "should get no songs by blank artist" do
    VCR.use_cassette("songs") do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: ""}
      assert_response :success
    end
  end

  test "should handle auth failures with invalid token" do
    genius_api = Genius::Song
    error = ->(params) { raise Genius::AuthenticationError.new }

    genius_api.stub :search, error do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
  end

  test "should handle auth failures with no token" do
    # TODO: Find better way, this is not good way!
    saved_token = Genius.access_token
    Genius.access_token = ''

    VCR.use_cassette("auth_errors") do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
    Genius.access_token = saved_token
  end

end
