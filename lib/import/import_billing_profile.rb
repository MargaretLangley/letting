require_relative 'import_contact'

module DB
  class ImportBillingProfile

    def self.import contents

      contents.each do |row|

        #This won't be the 1st time the human_id has been used since this is the billing address
        property = Property.where(human_id: row[:propertyid]).first_or_initialize

        # NO not new!!!!!


        property.entities[0].attributes = { title:    row[:title1],
                                            initials: row[:init1],
                                            name:     row[:name1] }

        property.entities[1].attributes = { title:    row[:title2],
                                            initials: row[:init2],
                                            name:     row[:name2] }

        property.address.attributes = { flat_no:    row[:flatno],
                                        house_name: row[:housename],
                                        road_no:    row[:rdno],
                                        road:       row[:rd],
                                        district:   row[:district],
                                        town:       row[:town],
                                        county:     row[:county],
                                        postcode:   row[:pc] }

        if property.human_id > 6000
          property.address.type = 'FlatAddress'
        else
          property.address.type = 'HouseAddress'
        end

        clean_addresses property

        property.build_billing_profile use_profile: false

        # puts property.inspect
        # puts property.entities.first.inspect
        print '.' if index % 100 == 0
        unless property.save
          puts "human propertyid: #{row[:propertyid]} -  #{property.errors.full_messages}"
        end
      end
    end

    def self.clean_addresses property

      property.address.attributes = { town: property.address.town.titleize }

    end

  end
end
