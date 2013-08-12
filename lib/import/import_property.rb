require_relative 'import_contact'

module DB
  class ImportProperty
    include ImportContact

    def self.import contents

      contents.each_with_index do |row, index|

        property = Property.where(human_property_id: row[:human_id]).first_or_initialize
        property.prepare_for_form
        property.assign_attributes human_property_id: row[:human_id], client_id: row[:clientid]
        self.import_contact property, row
        property.billing_profile.use_profile = false if property.new_record?

        # It's a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        unless property.save
          puts "human propertyid: #{row[:human_id]} -  #{property.errors.full_messages}"
        end

      end
    end

    def self.import_contact contactable, row
      self.entity contactable.entities[0],
          title: row[:title1], initials: row[:initials1], name: row[:name1]
      self.entity contactable.entities[1],
          title: row[:title2], initials: row[:initials2], name: row[:name2]
      self.address contactable.address,
                                   type:      self.address_type(row[:human_id]),
                                   flat_no:    row[:flat_no],
                                   house_name: row[:housename],
                                   road_no:    row[:road_no],
                                   road:       row[:road],
                                   district:   row[:district],
                                   town:       row[:town],
                                   county:     row[:county],
                                   postcode:   row[:postcode]
    end

    def self.address_type human_id
      human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end
  end
end
