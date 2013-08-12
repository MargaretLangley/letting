require_relative 'import_contact'

module DB
  class ImportProperty
    include ImportContact

    def self.import contents

      contents.each_with_index do |row, index|

        property = Property.where(human_property_id: row[:propertyid]).first_or_initialize
        property.prepare_for_form
        property.assign_attributes human_property_id: row[:propertyid], client_id: row[:clientid]
        self.import_contact property, row
        property.billing_profile.use_profile = false if property.new_record?

        # It's a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        unless property.save
          puts "human propertyid: #{row[:propertyid]} -  #{property.errors.full_messages}"
        end

      end
    end

    def self.import_contact property, row
      self.entity property.entities[0],
          { title: row[:title1], initials: row[:init1], name: row[:name1] }
      self.entity property.entities[1],
          { title: row[:title2], initials: row[:init2], name: row[:name2] }

      self.address property.address,
                                   type:       self.address_type(property),
                                   house_name: row[:housename],
                                   road_no:    row[:rdno],
                                   road:       row[:rd],
                                   district:   row[:district],
                                   town:       row[:town],
                                   county:     row[:county],
                                   postcode:   row[:pc]
    end

    def self.address_type property
      property.human_property_id > 6000 ? 'FlatAddress' : 'HouseAddress'
    end
  end
end
