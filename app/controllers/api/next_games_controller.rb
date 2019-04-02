require 'geocoder'

class Api::NextGamesController < ApplicationController

  # Methods not complete
  def index
    user = User.first
    current_location = {location: {lat: 43.64434, lng: -79.401984}}
    sports = user.sports

    # Find existing games
    current_games = {}
    sports.each do |sport|
      current_games[sport.name] = []
      games = sport.games


    # Find empty games
    new_parks = {}
    sports.each do |sport|
      new_parks[sport.name] = []
      facilities = sport.facilities
      facilities.each do |f|
        facility = {
          name: f.name,
          location: {
            lat: f.latitude,
            lng: f.longitude,
            dist: (Geocoder::Calculations.distance_between([current_location[:location][:lat], current_location[:location][:lng]], [f.latitude.to_f, f.longitude.to_f]) * 1.60934).round(2)
          }
        }
        new_parks[sport.name].push(facility)
      end
      new_parks[sport.name].sort! { |x,y| x[:location][:dist] <=> y[:location][:dist]}
      if new_parks[sport.name].count > 2
        new_parks[sport.name] = new_parks[sport.name].slice(0,2)
      end
    end
    # Make sure the user gets a game!
    empty_games = get_empty_games(user, current_location)
  end

  private

  def get_empty_games(user, current_location)

  end
end
