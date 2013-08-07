# require 'csv'

# desc "Import billing address data from CSV file"
# task import_address2: :environment do
#   puts "Start Import"

#   contents = CSV.open "import_data/address2.csv", headers: true, header_converters: :symbol
#   puts "Open File"

#   contents.each do |row|

#     address2 = Address2.where(human_client_id: row[:clientid]).first_or_create do |client|

#             human_property_id = row[:propertyid]
#             entity_title = row[:title1]
#             entity_initials = row[:init1|
#             entity_name = row[:name1]
#             # title2= row[:title2]
#             # init2 = row[:init2]
#             # name2 = row[:name2]

#             flatnum = row[:flatno]
#             housena = row[:housename]
#             roadno = row[:rdno]
#             road = row[:rd]
#             dist = row[:district]
#             tow = row[:town]
#             count = row[:county]
#             postcd = row[:pc]

#             if road == "210-214 Soho Road"
#              roadno = "210-214"
#              road = "Soho Road"
#             end


#             tow = tow.downcase.capitalize if tow =="SOLIHULL"
#             tow = tow.downcase.capitalize if tow =="BIRMINGHAM"


#             property.entities.new title: entity_title, initials: entity_initials, name: entity_name
#             # property.entities.new title: entity_title2, initials: entity_initials, name: entity_name
#             property.build_address flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
#         end
#         # puts property.inspect
#     puts "propertyid: #{row[:propertyid]} failed" if propertyid.nil?
#     begin
#         property.save!
#     rescue
#         puts property.errors.full_messages
#     end
#   end
# end
