module DB
  class ImportClient

    def self.import contents

      contents.each do |row|
        client = Client.where(human_client_id: row[:clientid]).first_or_initialize

        client.prepare_for_form

        client.human_client_id = row[:clientid]
        client.entities[0].attributes = { title:    row[:clienttitle],
                                          initials: row[:clientinit],
                                          name:     row[:clientname]   }
        client.entities[1].attributes = { title:    row[:clienttitle2],
                                          initials: row[:clientinit2],
                                          name:     row[:clientname2] }
        client.address.attributes = { type:       'FlatAddress',
                                     flat_no:    row[:flatno],
                                     house_name: row[:housename],
                                     road_no:    row[:rdno],
                                     road:       row[:rd],
                                     district:   row[:district],
                                     town:       row[:town],
                                     county:     row[:county],
                                     postcode:   row[:pc] }

        clean_addresses client
        clean_entities client

        unless client.save
          puts "human_clent_id: #{row[:clientid]} -  #{client.errors.full_messages}"
        end
      end
    end


    def self.clean_addresses client

      client.address.attributes = { town: client.address.town.titleize }
      client.address.attributes = { county: 'Bedfordshire' }  if client.address.county == "Bedford"

      waterloo client if client.address.road.ends_with? "Waterloo Street"

      client.address.attributes = { road: 'Bromsgrove Road', district: 'Clent', town: 'Stourbridge', county: 'West Midlands' } if client.address.road.ends_with? "Clent"
      client.address.attributes = { district: 'Hartlebury', town: 'Kidderminster', county: 'Worcestershire' }  if client.address.county == "Hartlebury"
      client.address.attributes = { district: '', town: 'Horsham'} if client.address.district == "Horsham"
      client.address.attributes = { town: 'Wolverhampton', county: 'West Midlands' } if client.address.county == "Wolverhampton"
      client.address.attributes = { town: 'Halesowen' } if client.address.postcode == "B62 8JA"
    end

    def self.waterloo client
      client.address.attributes = { road_no: '14' } if client.address.road.starts_with? '14'
      client.address.attributes = { road_no: '67' } if client.address.road.starts_with? '67'
      client.address.attributes = { road: 'Waterloo Street', town: 'Birmingham', county: 'West Midlands' }
    end

    def self.clean_entities client
      if client.entities[1].title.present? && client.entities[1].title.starts_with?("& M")
        client.entities[1].title.sub!("& M","M")
      end
    end

  end
end