module DB
  module ImportContact
    extend ActiveSupport::Concern

    def import_contact contactable, row
      entity contactable.entities[0],
          title: row[:title1], initials: row[:initials1], name: row[:name1]
      entity contactable.entities[1],
          title: row[:title2], initials: row[:initials2], name: row[:name2]
      address contactable.address,
                                   type:      address_type(contactable),
                                   flat_no:    row[:flat_no],
                                   house_name: row[:housename],
                                   road_no:    row[:road_no],
                                   road:       row[:road],
                                   district:   row[:district],
                                   town:       row[:town],
                                   county:     row[:county],
                                   postcode:   row[:postcode]
    end

    def address addressable, args = {}

      addressable.attributes = {  type:       args[:type],
                                  flat_no:    args[:flat_no],
                                  house_name: args[:house_name],
                                  road_no:    args[:road_no],
                                  road:       args[:road],
                                  district:   args[:district],
                                  town:       args[:town],
                                  county:     args[:county],
                                  postcode:   args[:postcode] }
    end


    def entity entity, args = {}
      entity.attributes = { title:    args[:title],
                            initials: args[:initials],
                            name:     args[:name] }
    end

    def clean_contact contactable
      clean_addresses contactable
      clean_entities contactable
    end

    def clean_addresses contactable
      addressable = contactable.address
      addressable.attributes = { town: addressable.town.titleize }
    end

    def clean_entities contactable
      entitiable = contactable.entities
      if entitiable[1] && entitiable[1].title.present? && entitiable[1].title.starts_with?("& M")
        entitiable[1].title.sub!("& M","M")
      end
    end

  end
end