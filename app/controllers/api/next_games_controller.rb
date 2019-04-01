class Api::NextGamesController < ApplicationController

  # Methods not complete
  def index
    if :current_user
      sample_park = {
        name: 'Fake Park',
        date: 'April 13',
        time: '2:00pm',
        latitude: -48.11111111,
        longitude: 73.11111111,
        players: 3,
        sport: 'basketball',
        note: 'The format of this object will change'
      }
      json_response(sample_park)
    else
      # error handle
    end
  end
end
