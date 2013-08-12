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

        # NOTE NO BILLING ADDRESS IS BEING IMPORTED
        property.build_billing_profile use_profile: false

        clean_addresses property

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

    def self.clean_addresses property

      property.address.attributes = { postcode: 'DY5 2QW' } if  property.address.road == "Barn Owl Walk"
      property.address.attributes = { postcode: 'WS9 8HG' } if  property.address.road == "Cliveden Avenue"
      property.address.attributes = { postcode: 'WS9 0HT' } if  property.address.road == "Nursery Avenue"
      property.address.attributes = { postcode: 'DY11 5HY' } if  property.address.road == "Puxton Drive"
      property.address.attributes = { postcode: 'WS10 9PF' } if  property.address.road == "Whitley Street"

      property.address.attributes = { district: 'Kingswinford', town: 'Dudley'} if property.address.town = "Kingswinford"
      property.address.attributes = { district: 'Kingswinford', town: 'Dudley'} if property.address.town = "KINGSWINFORD"

      property.address.attributes = {county: 'Worcestershire'} if  property.address.county == "Worcs"

    end

  end
end
