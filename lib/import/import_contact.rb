module DB
  module ImportContact
    extend ActiveSupport::Concern

    def import_contact contactable, row
      contactable.entities.each_with_index do |entity, index|
        assign_entity entity, index + 1, row
      end
      assign_address contactable.address, row
    end

    def assign_address address, row

      address.attributes = {      type:       address_type(row),
                                  flat_no:    row[:flat_no],
                                  house_name: row[:house_name],
                                  road_no:    row[:road_no],
                                  road:       row[:road],
                                  district:   row[:district],
                                  town:       row[:town],
                                  county:     row[:county],
                                  postcode:   row[:postcode] }
    end


    def assign_entity entity, number, row
      entity.attributes = { title:    row[:"title#{number}"],
                            initials: row[:"initials#{number}"],
                            name:     row[:"name#{number}"] }
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