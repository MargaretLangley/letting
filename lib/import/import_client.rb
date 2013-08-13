require_relative 'import_contact'

module DB
  class ImportClient
    include ImportContact
    attr_reader :contents

    def initialize contents
      @contents = contents
    end

    def self.import contents
      new(contents).do_it
    end

    def do_it

      contents.each_with_index do |row, index|

        client = Client.where(human_id: row[:human_id]).first_or_initialize
        client.prepare_for_form
        client.assign_attributes human_id: row[:human_id]
        import_contact client, row

        # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        clean_contact client
        unless client.save!
          puts "human_id: #{row[:human_id]} -  #{client.errors.full_messages}"
        end
      end
    end

    def address_type contactable
      'FlatAddress'
    end

    def clean_addresses addressable
      addressable.address.attributes = { town: addressable.address.town.titleize }
    end

    def clean_entities entitiable
      if entitiable.entities[1] && entitiable.entities[1].title.present? && entitiable.entities[1].title.starts_with?("& M")
        entitiable.entities[1].title.sub!("& M","M")
      end
    end

  end
end