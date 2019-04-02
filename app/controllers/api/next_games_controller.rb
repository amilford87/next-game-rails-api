require 'geocoder'

class Api::NextGamesController < ApplicationController

  # Methods not complete
  def index
    user = User.first
    current_location = {location: {lat: 43.64434, lng: -79.401984}}
    sports = user.sports

    # Find existing games
    existing_games = []
    sports.each do |sport|
      games = sport.games
      games.each do |g|
        existing_game = {
          type: 'active',
          date: g.date,
          image: g.sport.image,
          location: {
            lat: g.facility.latitude,
            lng: g.facility.longitude,
            dist: (Geocoder::Calculations.distance_between([current_location[:location][:lat], current_location[:location][:lng]], [g.facility.latitude.to_f, g.facility.longitude.to_f]) * 1.60934).round(2)
          },
          facility: g.facility.name,
          other_players: g.users.ids,
          sport: g.sport.name,
          time: g.start_time,
        }
        existing_games.push(existing_game)
      end
    end

    # Find empty games
    empty_games = {}
    sports.each do |sport|
      empty_games[sport.name] = []
      facilities = sport.facilities
      facilities.each do |f|
        new_game = {
          type: 'new',
          date: 'USER PREF HERE',
          image: sport.image,
          location: {
            lat: f.latitude,
            lng: f.longitude,
            dist: (Geocoder::Calculations.distance_between([current_location[:location][:lat], current_location[:location][:lng]], [f.latitude.to_f, f.longitude.to_f]) * 1.60934).round(2)
          },
          facility: f.name,
          other_players: 0,
          sport: sport.name,
          time: "USER PREF HERE"
        }
        empty_games[sport.name].push(new_game)
      end
      empty_games[sport.name].sort! { |x,y| x[:location][:dist] <=> y[:location][:dist]}
      if empty_games[sport.name].count > 2
        empty_games[sport.name] = empty_games[sport.name].slice(0,2)
      end
    end
    new_games = []
    empty_games.each_value do |s|
      s.each do |eg|
        new_games.push(eg)
      end
    end
  end

  private

  def get_empty_games(user, current_location)

  end
end
