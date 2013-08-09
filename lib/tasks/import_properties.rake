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

namespace :db do

  desc "Import properties data from CSV file"
  task  import_properties: :environment do
    puts "Start Import"

    contents = CSV.open "import_data/properties.csv", headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}

     puts 'open file'

      # contents.first(10).each do |row|
      #   puts row[:housename]
      # end



    contents.drop(33).each_with_index do |row, index|
      property = Property.where(human_property_id: row[:propertyid]).first_or_initialize
        flatnum = row[:flatno]
        housena = row[:housename]
        roadno = row[:rdno]
        road = row[:rd]
        dist = row[:district]
        tow = row[:town]
        count = row[:county]
        postcd = row[:pc]

        if tow.include? "Kingswinford"
          dist = "Kingswinford"
          tow = "Dudley"
        end

        if tow.include? "KINGSWINFORD"
          dist = "Kingswinford"
          tow = "Dudley"
        end

        if road.include? "Barn Owl"
          postcd = "DY5 2QW"
        end

        if road.include? "Cliveden"
          postcd = "WS9 8HG"
        end

        if road.include? "Nursery"
          postcd = "WS9 0HT"
        end

        if road.include? "Puxton"
          postcd = "DY11 5HY"
        end

       if road.include? "Whitley"
         postcd = "WS10 9PF"
       end

      if count.include? "Worcs"
          count = "Worcestershire"
      end



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
end