class HomeController < ApplicationController
  def landing_page
  end

  def fetch_artist_songs
    # Make sure we have valid params
    if params[:artist].blank?
      @error_message = I18n.t("errors.artist_blank")
      render "layouts/auth_error" and return
    end

    # Get songs by artist
    # Two different approaches were found, leaving both in for discussion on both ways...
    @songs = artist_songs_by_artist_id

    render "home/song_list"
  rescue Genius::AuthenticationError => e
    @error_message = if Genius.access_token.blank?
      I18n.t("errors.access_token_blank")
    else
      I18n.t("errors.access_token_invalid")
    end
    Rails.logger.error("Auth error encountered. Error: #{e.message}")
    render "layouts/auth_error"
  end

  private

  def artist_songs_by_artist_id
    artist = nil
    songs_by_artist = []
    page = 0

    # Search to find the artist first
    search_results = Genius::Song.search(params[:artist])
    search_results.each do |result|
      # Only add songs if the artist matches up
      if result.primary_artist.name.downcase == params[:artist].downcase
        artist = Genius::Artist.find(result.primary_artist.id)
        break
      end
    end

    # Return if no artist found
    return songs_by_artist unless artist.present?

    # lets find all songs by this artist
    loop do
      Rails.logger.info("Fetching songs for #{artist.name}, page #{page + 1} ")
      songs = artist.songs(params: {per_page: 50, page: (page += 1)})
      songs_by_artist += songs.select do |song|
        # Only add songs if the artist name matches up
        song.primary_artist.name == artist.name
      end

      # Ideally we should break if count is less that per_page,
      # however for some reason often API pages are not always full
      break if songs.count == 0
    end
    songs_by_artist
  end

  # def artist_songs_by_search
  #   songs_by_artist = []
  #   page = 0
  #   artist = params[:artist].downcase
  #
  #   # Use search API to find all songs by artist
  #   loop do
  #     Rails.logger.info("Fetching songs for #{artist}, page #{page + 1} ")
  #     songs = Genius::Song.search(artist, params: {per_page: 50, page: (page += 1)})
  #     songs_by_artist += songs.select do |song|
  #       # Only add songs if the artist name matches up
  #       song.primary_artist.name.downcase == artist
  #     end
  #
  #     # Ideally we should break if count is less than per_page,
  #     # however for some reason often API pages are not always full
  #     break if songs.count == 0
  #   end
  #
  #   # Sort sing list and return
  #   songs_by_artist.sort_by { |song| song.title }
  # end

end
