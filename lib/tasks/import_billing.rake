# CHANGES
# 1 Whitespace was not being stripped
#... had
   # "Mr and Mrs       "
#instead of
   #"Mr and Mrs"
# 2 first_or_create => first_or_initialize
#   This way we can update a property even if it has already been added.
# 3 Note:  contents.drop(33).take(2)  <--- great for debugging


require 'csv'

desc "Import properties data from CSV file"
task  import_billing: :environment do
  puts "Start Import"

  contents = CSV.open "import_data/address2.csv", headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}

   puts 'open file'



  contents.each_ do |row|
    property = Property.where(human_property_id: row[:propertyid]).first_or_initialize
      flatnum = row[:flatno]
      housena = row[:housename]
      roadno = row[:rdno]
      road = row[:rd]
      dist = row[:district]
      tow = row[:town]
      count = row[:county]
      postcd = row[:pc]

      tow = tow.capitalize if tow.include? "BIRMINGHAM"
      tow = tow.capitalize if tow.include? "PENKRIDGE"
      tow = tow.capitalize if tow.include? "SOLIHULL"

    property.assign_attributes human_property_id: row[:propertyid], client_id: row[:clientid]
    # NO not new!!!!!
    # property = Property.new human_property_id: row[:propertyid], client_id: row[:clientid]
    property.entities.new title: row[:title1], initials: row[:init1], name: row[:name1]
    property.entities.new title: row[:title2], initials: row[:init2], name: row[:name2]
    property.build_address flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
    if property.human_property_id > 6000
      property.address.type = 'FlatAddress'
    else
      property.address.type = 'HouseAddress'
    end
    property.build_billing_profile use_profile: false

    # puts property.inspect
    # puts property.entities.first.inspect
    print '.' if index % 100 == 0
    unless property.save
      puts "human propertyid: #{row[:propertyid]} -  #{property.errors.full_messages}"
    end
  end
end