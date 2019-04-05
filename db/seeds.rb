# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding Data..."

# def open_asset(file_name)
#     File.open(Rails.root.join('db', 'assets', file_name))
# end

unless Rails.env.development?
    puts "Development seeds only (for now)!"
    exit 0
end

puts "Re-creating Facilities..."

#Delete everything first
Game.destroy_all
Facility.destroy_all
Sport.destroy_all

# facility1 = Facility.create!({
#     name: "Christie Pits Park",
#     latitude: 43.6646,
#     longitude: -79.4207,
# })

# facility2 = Facility.create!({
#     name: "Dovercourt Park",
#     latitude: 43.6658,
#     longitude: -79.4338,
# })

# facility3 = Facility.create!({
#     name: "Grange Park",
#     latitude: 43.6537,
#     longitude: -79.3930,
# })

# facility4 = Facility.create!({
#     name: "Inukshuk Park",
#     latitude: 43.6324,
#     longitude: -79.4095,
# })

# facility5 = Facility.create!({
#     name: "Village of Yorkville Park",
#     latitude: 43.6700,
#     longitude: -79.3917,
# })

puts "Re-creating Sports..."


basketball = Sport.create!({
    name: "Basketball",
    image: 'https://github.com/MattccTO/next-game-rails-api/blob/master/db/assets/sport-image/pickupBasketball.jpg?raw=true'
})

frisbee = Sport.create!({
    name: "Ultimate-frisbee",
    image: 'https://github.com/MattccTO/next-game-rails-api/blob/master/db/assets/sport-image/pickupFrisbee.jpeg?raw=true'
})

soccer = Sport.create!({
    name: "Soccer",
    image: 'https://github.com/MattccTO/next-game-rails-api/blob/master/db/assets/sport-image/pickupSoccer.jpg?raw=true'
})

tennis = Sport.create!({
    name: "Tennis",
    image: 'https://github.com/MattccTO/next-game-rails-api/blob/master/db/assets/sport-image/pickupTennis.jpg?raw=true'
})

volleyball = Sport.create!({
    name: "Volleyball",
    image: 'https://github.com/MattccTO/next-game-rails-api/blob/master/db/assets/sport-image/pickupVolleyball.png?raw=true'
})

#make new seed facilities
facilities = JSON.parse(File.read(Rails.root.join('db', 'assets', 'toronto-park-facility.json')), :symbolize_names => true)
facilities.each do |f|
    current_facility = Facility.create!({
        name: f[:name],
        latitude: f[:latitude].to_f,
        longitude: f[:longitude].to_f
    })
    if f[:basketball]
        current_facility.sports << Sport.find(1)
    end
    if f[:volleyball]
        current_facility.sports << Sport.find(5)
    end
    if f[:tennis]
        current_facility.sports << Sport.find(4)
    end
    if f[:sportField]
        current_facility.sports << Sport.find(2, 3)
    end
end

# puts "Joining Facilities and Sports..."

# facility1.sport_ids = Sport.first.id, (Sport.first.id + 1), (Sport.first.id + 2)
# facility1.save

# facility2.sport_ids = Sport.first.id, (Sport.first.id + 1), (Sport.first.id + 2), (Sport.first.id + 3)
# facility2.save

# facility3.sport_ids = (Sport.first.id + 4), (Sport.first.id + 3), Sport.first.id
# facility3.save

# facility4.sport_ids = Sport.first.id, (Sport.first.id + 1), (Sport.first.id + 2), (Sport.first.id + 3), (Sport.first.id + 4)
# facility4.save

# facility5.sport_ids = Sport.first.id, (Sport.first.id + 3), (Sport.first.id + 4)
# facility5.save

puts "Re-creating Users..."

User.destroy_all

user1 = User.create!({
    username: "Test",
    email: "test@email.com",
    password: 'password',
    image: 'none'
})

user2 = User.create!({
    username: "User2",
    email: "user2@email.com",
    password: 'password',
    image: 'none'
})

user3 = User.create!({
    username: "User3",
    email: "user3@email.com",
    password: 'password',
    image: 'none'
})

user4 = User.create!({
    username: "User4",
    email: "user4@email.com",
    password: 'password',
    image: 'none'
})

user5 = User.create!({
    username: "User5",
    email: "user5@email.com",
    password: 'password',
    image: 'none'
})

100.times do
    User.create!({
        username: Faker::Internet.username,
        email: Faker::Internet.email,
        password: 'password',
        image: 'none'
    })
end

puts "Re-creating User Time Preferences..."

Timepref.destroy_all

days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']

User.all.each do |u|
    days.each do |d|
        u.timeprefs.create!({
            week_day: d,
            active: false
        })
    end
end

timepref1 = user1.timeprefs.find_by(week_day: 'monday')
timepref1.start_time = '10:00'
timepref1.end_time = '20:00'
timepref1.active = true
timepref1.save

timepref2 = user1.timeprefs.find_by(week_day: 'wednesday')
timepref2.start_time = '8:00'
timepref2.end_time = '10:00'
timepref2.active = true
timepref2.save

timepref3 = user1.timeprefs.find_by(week_day: 'sunday')
timepref3.start_time = '9:00'
timepref3.end_time = '16:00'
timepref3.active = true
timepref3.save

timepref4 = user3.timeprefs.find_by(week_day: 'tuesday')
timepref4.start_time = '10:00'
timepref4.end_time = '20:00'
timepref4.active = true
timepref4.save

timepref5 = user3.timeprefs.find_by(week_day: 'thursday')
timepref5.start_time = '12:00'
timepref5.end_time = '16:00'
timepref5.active = true
timepref5.save

timepref6 = user3.timeprefs.find_by(week_day: 'saturday')
timepref6.start_time = '9:00'
timepref6.end_time = '20:00'
timepref6.active = true
timepref6.save



# timepref3 = user1.timeprefs.create!({
#     week_day: 'Sunday',
#     start_time: '9:00',
#     end_time: '16:00'
# })

# timepref4 = user3.timeprefs.create!({
#     week_day: 'Tuesday',
#     start_time: '10:00',
#     end_time: '20:00'
# })

# timepref5 = user3.timeprefs.create!({
#     week_day: 'Thursday',
#     start_time: '12:00',
#     end_time: '16:00'
# })

# timepref6 = user3.timeprefs.create!({
#     week_day: 'Saturday',
#     start_time: '9:00',
#     end_time: '20:00'
# })


puts "Re-creating Games..."


game1 = Game.create!({
    date: '2019-04-01',
    start_time: '12:00:00',
    facility_id: Facility.first.id,
    sport_id: Sport.first.id
})

game2 = Game.create!({
    date: '2019-04-01',
    start_time: '14:00:00',
    facility_id: (Facility.first.id + 1),
    sport_id: (Sport.first.id + 1)
})

game3 = Game.create!({
    date: '2019-04-03',
    start_time: '08:30:00',
    facility_id: (Facility.first.id + 2),
    sport_id: (Sport.first.id + 2)
})

game4 = Game.create!({
    date: '2019-04-02',
    start_time: '16:00:00',
    facility_id: (Facility.first.id + 3),
    sport_id: (Sport.first.id + 3)
})

game5 = Game.create!({
    date: '2019-04-02',
    start_time: '18:00:00',
    facility_id: (Facility.first.id + 4),
    sport_id: (Sport.first.id + 4)
})

all_Facilities = Facility.all.to_a
d = Date.today
dates = [d, Date.tomorrow, (d+2), (d+3), (d+4), (d+5), (d+6)]
minute = ['00', '30']


100.times do
    hour = rand(06..22).to_s
    date_sample = dates.sample.to_s 
    
    temp_game = Game.new
    temp_game.date = date_sample
    temp_game.start_time = hour + ":" + minute.sample
    temp_game.facility_id = all_Facilities.sample.id
    temp_game.sport_id = Facility.find(temp_game.facility_id).sports.sample.id
    
    temp_game.save
end

puts "Joining Sports and Users..."

basketball.users << User.find((1..60).to_a)

frisbee.users << User.find((50..80).to_a)

soccer.users << User.find((1..80).to_a)

tennis.users << User.find((70..100).to_a)

volleyball.users << User.find((60..100).to_a)

puts "Joining Games and Users..."

count = 1
users = User.all
100.times do
    user_array = []
    user_temp_game = Game.find(count)
    temp_game_sport = user_temp_game.sport_id
    users.each do |user|
        if user.sports.ids.include? temp_game_sport
            user_array.push(user)
        end
    end
    
    
    user_count = rand(1..4)

    game_users = []

    user_count.times do
    game_users.push(user_array.slice!(rand(0..(user_array.count - 1))))
    end

    user_temp_game.users = game_users
    user_temp_game.save
    count = count + 1
end

game_one = Game.find(23)
game_two = Game.find(57)
game_three = Game.find(13)

user1.games = game_one, game_two, game_three
user1.save

puts "done!"
