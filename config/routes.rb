Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get "home/fetch_artist_songs", to: "home#fetch_artist_songs", as: :fetch_artist_songs
  root "home#landing_page"
end
