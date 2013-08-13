require_relative 'import_contact'

module DB
  class ImportClient
    include ImportContact

    def self.import contents

      contents.each do |row|

        client = Client.where(human_id: row[:human_id]).first_or_initialize
        client.prepare_for_form
        client.human_id = row[:human_id]
        import_contact client, row

        clean_addresses client
        clean_entities client
        unless client.save!
          puts "human_id: #{row[:human_id]} -  #{client.errors.full_messages}"
        end
      end
    end

    def self.import_contact contactable, row
      self.entity contactable.entities[0],
          title: row[:title1], initials: row[:initials1], name: row[:name1]
      self.entity contactable.entities[1],
          title: row[:title2], initials: row[:initials2], name: row[:name2]
      self.address contactable.address,
                                   type:      self.address_type(contactable),
                                   flat_no:    row[:flat_no],
                                   house_name: row[:housename],
                                   road_no:    row[:road_no],
                                   road:       row[:road],
                                   district:   row[:district],
                                   town:       row[:town],
                                   county:     row[:county],
                                   postcode:   row[:postcode]
    end

    def self.address_type contactable
      'FlatAddress'
    end

    def self.clean_addresses client
      client.address.attributes = { town: client.address.town.titleize }
    end

    def self.clean_entities client
      if client.entities[1].title.present? && client.entities[1].title.starts_with?("& M")
        client.entities[1].title.sub!("& M","M")
      end
    end

  end
end