require 'csv'

namespace :db do
  desc "Import clients data from CSV file"
  task import_clients: :environment do
    puts "Start Import"

    contents = CSV.open "import_data/clients.csv", headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}
    puts "Open File"

    contents.each do |row|
      # tried putting do in line below but 'client.human_client_id =  ' becomes undefined method
      client = Client.where(human_client_id: row[:clientid]).first_or_initialize
        puts "*#{row[:clientid]}*"
        human_client_id = row[:clientid]
        puts "*#{human_client_id}*"
        entity_title = row[:clienttitle]
        entity_initials = row[:clientinit]
        entity_name = row[:clientname]
        title2= row[:clienttitle2]
        init2 = row[:clientinit2]
        name2 = row[:clientname2]

        flatnum = row[:flatno]
        housena = row[:housename]
        roadno = row[:rdno]
        road = row[:rd]
        dist = row[:district]
        tow = row[:town]
        count = row[:county]
        postcd = row[:pc]

        if human_client_id == "27"
         road = "No"
         tow = "Address"
         count = "Known"
        end;

     #  client.attributes road: no / town: 'addres'    if human_client_id = "27"

        title2.sub!("& M","M") if title2.include? "& M"

        if road.include? "14"
         roadno = "14"
         road = "Waterloo Street"
         tow = "Birmingham"
         count = "West Midlands"
         puts "14"
        end

        if road.include? "67"
         roadno = "67"
         road = "Waterloo Street"
         tow = "Birmingham"
         count = "West Midlands"
          puts "67"
        end

        if road.include? "Clent"
         road = "Bromsgrove Road"
         dist = "Clent"
         tow = "Stourbridge"
         count = "West Midlands"
        end

        if dist.include? "Horsham"
          dist = ""
          tow = "Horsham"
        end

        if count.include? "Hartlebury"
          dist = "Hartlebury"
          tow = "Kidderminster"
          count = "Worcestershire"
        end

        if count.include? "Wolverhampton"
          tow = "Wolverhampton"
          count = "West Midlands"
        end

        if postcd.include? "B62 8JA"
          tow = "Halesowen"
          count = "West Midlands"
        end

        count = "Bedfordshire" if count.include? "Bedford"
        tow = tow.capitalize if tow.include? "SOLIHULL"

        client.human_client_id = human_client_id
        client.entities.new title: entity_title, initials: entity_initials, name: entity_name
        client.entities.new title: title2, initials: init2, name: name2
        client.build_address type: 'FlatAddress', flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
      # puts client.inspect
        unless client.save
          puts "human_clent_id: #{row[:clientid]} -  #{client.errors.full_messages}"
        end
      end
  end
end