class HomeController < ApplicationController
  def landing_page
  end

  def fetch_artist_songs
    artist = params[:artist]
    songs = Genius::Song.search(artist)
    @songs = songs.select do |song|
      # Only add songs if the artist matches up
      song.primary_artist.name == artist
    end

    render "home/song_list"
  rescue Genius::AuthenticationError => e
    if Genius.access_token.blank?
      @error_message = "Your access token is blank, please check..."
    else
      @error_message = "Your access token is invalid, please check..."
    end
    render "layouts/auth_error"
  end

end