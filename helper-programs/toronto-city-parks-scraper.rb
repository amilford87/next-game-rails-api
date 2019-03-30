require 'open-uri'
require 'nokogiri'
require 'json'
require 'byebug'

torontoParks =  JSON.parse(File.read('../db/assets/toronto-parks.json'))

# puts torontoParks

# torontoParks.each { |park| puts park["ID"] }
parkData = []

torontoParks.each do |park|

  url = "https://www.toronto.ca/data/parks/prd/facilities/complex/#{park['ID']}/index.html"
  parkPage = Nokogiri::HTML(open(url))
  park = {
    name: park["Name"],
    latitude: park["Y"],
    longitude: park["X"]
  }

  parkPage.css("#pfrComplexTabs-facilities tr").each do |tr|
    if tr.css("th").text.include? "Basketball"
      park['basketball'] = true
    elsif tr.css("th").text.include? "Volleyball"
      park['volleyball'] = true
    elsif tr.css("th").text.include? "Tennis"
      park['tennis'] = true
    elsif tr.css("th").text.include? ("Sport Field" || "Multipurpose Field")
      park['sportField'] = true
    end

    if !park.key?('basketball')
      park['basketball'] = false
    end
    if !park.key?('volleyball')
      park['volleyball'] = false
    end
    if !park.key?('tennis')
      park['tennis'] = false
    end
    if !park.key?('sportField')
      park['sportField'] = false
    end
    # puts "Facility: #{tr.css("th").text} | Present: #{tr.css("td").text.to_i > 0}"
  end

  if (park['basketball'] == true || park['volleyball'] == true || park['tennis'] == true || park['sportField'] == true)
    parkData.push(park)
  end
end

File.open("../db/assets/toronto-park-facility.json", "w") do |f|
  f.write(JSON.pretty_generate(parkData))
end