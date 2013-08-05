require 'csv'

desc "Import properties data from CSV file"
task  import_properties: :environment do
  puts "Start Import"

  contents = CSV.open "import_data/properties.csv", headers: true, header_converters: :symbol
  puts "Open File"

  contents.drop(33).each do |row|
    human_property_id = row[:propertyid]
    client_id = row[:clientid]

    entity_title = row[:title1]
    entity_initials = row[:init1]
    entity_name = row[:name1]

    flatnum = row[:flatno]
    housena = row[:housename]
    roadno = row[:rdno]
    road = row[:rd]
    dist = row[:district]
    tow = row[:town]
    count = row[:county]
    postcd = row[:pc]
    puts "**" + entity_name

    property = Property.new human_property_id: human_property_id, client_id: client_id
    property.entities.new title: entity_title, initials: entity_initials, name: entity_name
    # client.entities.new title: entity_title2, initials: entity_initials, name: entity_name
    property.build_address flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
    property.save!

    puts property.inspect
    puts property.entities.first.inspect

  end
end