class Api::PreferencesController < ApplicationController

  def show
    @user = User.find(1)
    user_sports = @user.sports
    sport_prefs = []
    user_sports.each do |s|
      sport_prefs.push({ :value => s.name.downcase, :label => s.name })
    end
    times = @user.timeprefs
    time_prefs = {}
    times.each do |t|
      if t.active
        week_day_string = t.week_day.downcase
        time_prefs[week_day_string] = true
        start_string = t.week_day.downcase + 'Start'
        time_prefs[start_string] = t.start_time.strftime("%I:%M %p")
        end_string = t.week_day.downcase + 'End'
        time_prefs[end_string] = t.end_time.strftime("%I:%M %p")
      end
    end
    prefs = {
      :selectedDays => time_prefs,
      :sports => sport_prefs
    }
  end
end
