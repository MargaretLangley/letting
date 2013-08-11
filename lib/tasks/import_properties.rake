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

  def kingswinford property
    property.address.dist = "Kingswinford"
    property.address.town = "Dudley"
  end

  def clean_addresses property

    property.address.postcd = "DY5 2QW" if  property.address.road.include? "Barn Owl"
    property.address.postcd = "WS9 8HG" if  property.address.road.include? "Cliveden"
    property.address.postcd = "WS9 0HT" if  property.address.road.include? "Nursery"
    property.address.postcd = "DY11 5HY" if  property.address.road.include? "Puxton"
    property.address.postcd = "WS10 9PF" if  property.address.road.include? "Whitley"

    kingswinford if property.address.town =  "Kingswinford"
    kingswinford if property.address.town =  "KINGSWINFORD"

    property.address.county = "Worcestershire" if  property.address.county == "Worcs"

    # pro.atrribute postcode: postcode

  end


  desc "Import properties data from CSV file"
  task  import_properties: :environment do
    puts "Start Import"

    contents = CSV.open "import_data/properties.csv", headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}
    puts "Open File"
    contents.drop(33).each_with_index do |row, index|

      # puts Property.where(human_property_id: row[:propertyid]).to_sql
      property = Property.where(human_property_id: row[:propertyid]).first_or_initialize

       property.assign_attributes human_property_id: row[:propertyid], client_id: row[:clientid]
      # NO not new!!!!!
      # property = Property.new human_property_id: row[:propertyid], client_id: row[:clientid]
        property.entities.new title:    row[:Title1],
                              initials: row[:Init1],
                              name:     row[:Name1]

         property.entities.new title:    row[:Title2],
                               initials: row[:Init2],
                               name:     row[:Name2]

        property.build_address flat_no: row[:flatno],
                             house_name: row[:housename],
                             road_no:    row[:rdno],
                             road:       row[:rd],
                             district:   row[:district],
                             town:       row[:town],
                             county:     row[:county],
                             postcode:   row[:pc]

      if property.human_property_id > 6000
        property.address.type = 'FlatAddress'
      else
        property.address.type = 'HouseAddress'
      end
      property.build_billing_profile use_profile: false

      clean_addresses (property)

      # puts property.inspect
      # puts property.entities.first.inspect
      print '.' if index % 100 == 0
      unless property.save
        puts "human propertyid: #{row[:propertyid]} -  #{property.errors.full_messages}"
      end
    end
  end
end