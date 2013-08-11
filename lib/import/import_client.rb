module DB
  class ImportClient

    def self.import contents

      contents.each do |row|
        client = Client.where(human_client_id: row[:clientid]).first_or_initialize

        if client.new_record?
          client.prepare_for_form
        end

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

        # IF CODE GOES HERE

        unless client.save
          puts "human_clent_id: #{row[:clientid]} -  #{client.errors.full_messages}"
        end
      end
    end
  end
end