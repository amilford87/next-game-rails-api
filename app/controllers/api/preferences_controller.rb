class Api::PreferencesController < ApplicationController

  def show
    if @user = User.find(current_user.id)
      user_sports = @user.sports
      sport_prefs = []
      user_sports.each do |s|
        sport_prefs.push(s.name)
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
      render json: prefs, status: 200
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  def update
    if @user = User.find(current_user.id)
      user_sports = @user.sports

    end
  end

  private


end


#<ActionController::Parameters {"user"=>{"sports"=>["basketball", "volleyball", "tennis"], "selectedDays"=>{"monday"=>false, "tuesday"=>true, "wednesday"=>false, "thursday"=>false, "friday"=>true, "saturday"=>false, "sunday"=>false, "tuesdayStart"=>"11:00", "fridayEnd"=>"23:00"}}, "controller"=>"api/preferences", "action"=>"update", "user_id"=>"1", "preference"=>{"user"=>{"sports"=>["basketball", "volleyball", "tennis"], "selectedDays"=>{"monday"=>false, "tuesday"=>true, "wednesday"=>false, "thursday"=>false, "friday"=>true, "saturday"=>false, "sunday"=>false, "tuesdayStart"=>"11:00", "fridayEnd"=>"23:00"}}}} permitted: false>
