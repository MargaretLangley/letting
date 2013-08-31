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

      address.attributes = { flat_no:    row[:flat_no],
                             house_name: row[:house_name],
                             road_no:    row[:road_no],
                             road:       row[:road],
                             district:   row[:district],
                             town:       row[:town],
                             county:     row[:county],
                             postcode:   row[:postcode] }
    end

    def assign_entity entity, number, row
      entity.attributes = { type:     entity_type(row),
                            title:    row[:"title#{number}"],
                            initials: row[:"initials#{number}"],
                            name:     row[:"name#{number}"] }
    end

    def entity_type row
      row[:'title1'].present? ? 'Person' : 'Company'
    end

    def clean_contact contactable
      clean_addresses contactable
      clean_entities contactable
    end

    def clean_addresses contactable
      addressable = contactable.address
      addressable.attributes = \
        { town: addressable.town.titleize } if addressable.town.present?
    end

    def clean_entities contactable
      entitiable = contactable.entities
      if entity_title_starts_with_ampersand? entitiable[1]
        remove_ampersand_from_entity_title entitiable[1]
      end
    end

    def entity_title_starts_with_ampersand? entity
      entity && entity.title.present? && entity.title.starts_with?("& M")
    end

    def remove_ampersand_from_entity_title entity
      entity.title.sub!("& M","M")
    end

  end
end