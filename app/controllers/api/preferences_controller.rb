class Api::PreferencesController < ApplicationController

  # Show a user their preferences page
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
          time_prefs[start_string] = t.start_time.strftime("%H:%M")
          end_string = t.week_day.downcase + 'End'
          time_prefs[end_string] = t.end_time.strftime("%H:%M")
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

  # Update user preferences
  def update
    # Check if user
    if @user = User.find(current_user.id)
      user_current_sports = []
      @user.sports.each do |s|
        user_current_sports.push(s.name)
      end

      # Determine sports to join/de-join
      user_new_sports = pref_params[:sports]
      add_sports = user_new_sports - user_current_sports
      remove_sports = user_current_sports - user_new_sports

      # Join new sports
      if add_sports.count > 0
        add_sports.each do |as|
          sport_pointer = Sport.find_by(name: as)
          sport_pointer.users << @user
        end
      end

      # Remove joins to sports
      if remove_sports.count > 0
        remove_sports.each do |ds|
          sport_pointer = Sport.find_by(name: ds)
          @user.sports.destroy(sport_pointer)
        end
      end

      # Establish time preferences to change by comparing new to old
      user_current_timeprefs = @user.timeprefs.where(active: true).pluck(:week_day)
      user_new_timeprefs = user_active_days(pref_params[:selectedDays])
      add_days = user_new_timeprefs - user_current_timeprefs
      remove_days = user_current_timeprefs - user_new_timeprefs
      stay_days = user_current_timeprefs - remove_days

      if add_days.count > 0
        add_days.each do |ad|
          day_pref_pointer = Timepref.where(user_id: @user.id, week_day: ad)
          start_time_symbol = (ad.downcase + 'Start').to_sym
          end_time_symbol = (ad.downcase + 'End').to_sym
          day_pref_pointer.update(
            active: true,
            start_time: pref_params[:selectedDays][start_time_symbol],
            end_time: pref_params[:selectedDays][end_time_symbol]
          )
        end
      end

      if remove_days.count > 0
        remove_days.each do |rd|
          day_pref_pointer = Timepref.where(user_id: @user.id, week_day: rd)
          day_pref_pointer.update(active: false, start_time: nil, end_time: nil)
        end
      end

      if stay_days.count > 0
        stay_days.each do |sd|
          day_pref_pointer = Timepref.where(user_id: @user.id, week_day: sd)
          start_time_symbol = (sd.downcase + 'Start').to_sym
          end_time_symbol = (sd.downcase + 'End').to_sym
          day_pref_pointer.update(
            start_time: pref_params[:selectedDays][start_time_symbol],
            end_time: pref_params[:selectedDays][end_time_symbol]
          )
        end
      end

      render status: 201
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  private

  def pref_params
    params.require(:prefs).permit!
  end

  def user_active_days(day_prefs)
    user_active_days = []
    day_prefs.each_pair do |key, value|
      if value == true
        user_active_days.push(key)
      end
    end
    user_active_days
  end
end