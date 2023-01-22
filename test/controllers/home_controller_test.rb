require "test_helper"
require 'minitest/autorun'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    Genius.access_token = 'some invalid access token'
  end

  test "should get landing_page" do
    get root_path
    assert_response :success
  end

  test "should get songs" do
    genius_api = Genius::Song
    mock = Minitest::Mock.new
    mock_song = Minitest::Mock.new
    mock_song.expect :title, "Some Fancy Song Title"
    songs = [mock_song]
    mock.expect :select, songs

    genius_api.stub :search, mock do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
  end

  test "should handle auth failures" do
    genius_api = Genius::Song
    error = ->(params) { raise Genius::AuthenticationError.new }

    genius_api.stub :search, error do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
  end

  test "should handle auth failures with no token" do
    Genius.access_token = ''
    genius_api = Genius::Song
    error = ->(params) { raise Genius::AuthenticationError.new }

    genius_api.stub :search, error do
      get fetch_artist_songs_path, params: {format: "turbo_stream", artist: "Peter Gabriel"}
      assert_response :success
    end
  end

end
