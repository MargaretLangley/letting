require_relative 'import_contact'

module DB
  class ImportProperty
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

        property = Property.where(human_id: row[:human_id]).first_or_initialize
        property.prepare_for_form
        property.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
        import_contact property, row
        property.billing_profile.use_profile = false if property.new_record?

        # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        clean_contact property
        unless property.save
          puts "human propertyid: #{row[:human_id]} -  #{property.errors.full_messages}"
        end

      end
    end

    def address_type contactable
      contactable.human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
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
