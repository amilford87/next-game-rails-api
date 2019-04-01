# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding Data..."

def open_asset(file_name)
    File.open(Rails.root.join('db', 'assets', 'sport-image', file_name))
end

unless Rails.env.development?
    puts "Development seeds only (for now)!"
    exit 0
end

puts "Re-creating Facilities"

#Delete everything first
Game.destroy_all
Facility.destroy_all
Sport.destroy_all

#make new seed users
facility1 = Facility.create!({
    name: "Christie Pits Park",
    latitude: 43.6646,
    longitude: -79.4207,
})

facility2 = Facility.create!({
    name: "Dovercourt Park",
    latitude: 43.6658,
    longitude: -79.4338,
})

facility3 = Facility.create!({
    name: "Grange Park",
    latitude: 43.6537,
    longitude: -79.3930,
})

facility4 = Facility.create!({
    name: "Inukshuk Park",
    latitude: 43.6324,
    longitude: -79.4095,
})

facility5 = Facility.create!({
    name: "Village of Yorkville Park",
    latitude: 43.6700,
    longitude: -79.3917,
})

puts "Re-creating Sports"


basketball = Sport.create!({
    name: "Basketball",
    image: open_asset('pickupBasketball.jpg')
})

frisbee = Sport.create!({
    name: "Frisbee",
    image: open_asset('pickupFrisbee.jpeg')
})

soccer = Sport.create!({
    name: "Soccer",
    image: open_asset('pickupSoccer.jpg')
})

tennis = Sport.create!({
    name: "Tennis",
    image: open_asset('pickupTennis.jpg')
})

volleyball = Sport.create!({
    name: "Volleyball",
    image: open_asset('pickupVolleyball.png')
})

# puts "Re-creating Users"

# User.destroy_all

# user1 = User.create!({
#     username: "Test_User1",
#     email: "test_user1@email.com"
# })

# user2 = User.create!({
#     username: "Another_User",
#     email: "another_user@email.com"
# })

# user3 = User.create!({
#     username: "Frisbee_Guy",
#     email: "frisbee_guy@email.com"
# })

# user4 = User.create!({
#     username: "Sports_dude",
#     email: "sports_dude@email.com"
# })

# user5 = User.create!({
#     username: "Volleyballer",
#     email: "volleyballer@email.com"
# })

puts "Re-creating Games"


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

puts "done!"
