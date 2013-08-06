require 'csv'

desc "Import clients data from CSV file"
task import_clients: :environment do
  puts "Start Import"

  contents = CSV.open "import_data/clients.csv", headers: true, header_converters: :symbol
  puts "Open File"

  contents.each do |row|

    client = Client.where(human_client_id: row[:clientid]).first_or_create do |client|

            human_client_id = row[:clientid]
            entity_title = row[:clienttitle]
            entity_initials = row[:clientinit]
            entity_name = row[:clientname]
            # title2= row[:clienttitle2]
            # init2 = row[:clientinit2]
            # name2 = row[:clientname2]

            flatnum = row[:flatno]
            housena = row[:housename]
            roadno = row[:rdno]
            road = row[:rd]
            dist = row[:district]
            tow = row[:town]
            count = row[:county]
            postcd = row[:pc]

            if road == "14 Waterloo Street"
             roadno = "14"
             road = "Waterloo Street"
             count = "West Midlands"
             tow = "Birmingham"
            end


            if human_client_id == 18
             roadno = "-"
             dist = "-"
             road = "-"
             count = "-"
             tow = "-"
             postcd = "-"

            end

            tow = tow.downcase.capitalize if tow =="SOLIHULL"

            client.human_client_id = human_client_id
            client.entities.new title: entity_title, initials: entity_initials, name: entity_name
            # client.entities.new title: entity_title2, initials: entity_initials, name: entity_name
            client.build_address flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
        end
        # puts client.inspect
    puts "clientid: #{row[:clientid]} failed" if client.id.nil?
    begin
        client.save!
    rescue
        puts client.errors.full_messages
    end
  end
end
