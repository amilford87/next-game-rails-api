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
          date: g.date.strftime("%A %d of %B %Y"),
          image: g.sport.image,
          location: {
            lat: g.facility.latitude,
            lng: g.facility.longitude
          },
          dist: (Geocoder::Calculations.distance_between([current_location[:location][:lat], current_location[:location][:lng]], [g.facility.latitude.to_f, g.facility.longitude.to_f]) * 1.60934).round(2),
          facility: g.facility.name,
          other_players: g.users.ids,
          sport: g.sport.name,
          time: g.start_time.strftime("%I:%M %p")
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
            lng: f.longitude
          },
          dist: (Geocoder::Calculations.distance_between([current_location[:location][:lat], current_location[:location][:lng]], [f.latitude.to_f, f.longitude.to_f]) * 1.60934).round(2),
          facility: f.name,
          other_players: [],
          sport: sport.name,
          time: "USER PREF HERE"
        }
        empty_games[sport.name].push(new_game)
      end
      empty_games[sport.name].sort! { |x,y| x[:dist] <=> y[:dist]}
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

    next_games = existing_games.concat new_games
    applyGameWeight(next_games).sort! { |x,y| y[:weighted_score] <=> x[:weighted_score]}
    next_games = next_games.slice(0, 5)
    render json: next_games, status: 200
  end

  private

  def applyGameWeight(games)
    games.each do |g|
      # Distance
      distance_weight = (2.5 * Math.tanh(2.5 - (1.4 * Math.sqrt(g[:dist]))) + 2.5) # ((-0.75 * g[:dist]) + 5)
      if distance_weight < 0 then distance_weight = 0 end
      # y=2.5 * tanh(2.5-1.3 * sqrt{x})+2.5
      # Players
      player_weight = 1.3 * g[:other_players].count
      if player_weight > 7.5 then player_weight = 7.5 end
      g[:weighted_score] = (distance_weight + player_weight).round(3)
    end
    games
  end
end
