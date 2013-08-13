require_relative 'import_contact'

module DB
  class ImportBillingProfile
    include ImportContact

    def self.import contents

      contents.each_with_index do |row, index|

        property = Property.where(human_id: row[:human_id]).first_or_initialize
        billing_profile = property.billing_profile
        billing_profile.prepare_for_form property
        billing_profile.assign_attributes use_profile: true
        self.import_contact billing_profile, row

        # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        clean_addresses billing_profile
        clean_entities billing_profile
        unless billing_profile.save
          puts "human propertyid: #{row[:propertyid]} -  #{billing_profile.errors.full_messages}"
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

    def self.clean_addresses addressable
      addressable.address.attributes = { town: addressable.address.town.titleize }
    end

    def self.clean_entities entitiable
      if entitiable.entities[1] && entitiable.entities[1].title.present? && entitiable.entities[1].title.starts_with?("& M")
        entitiable.entities[1].title.sub!("& M","M")
      end
    end

    def self.address_type human_id
      human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
