module DB
  ####
  #
  # ImportContact
  #
  # Shared code for the importing of contact data (entities + address)
  #
  # Contact data is used on Property, billing_profile and Client data
  # This is used during the import of these model's data.
  #
  ####
  #
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
      if person? row, number
        assign_person entity, number, row
      else
        assign_company entity, number, row
      end
    end

    def assign_person entity, number, row
      entity.attributes = { entity_type:  entity_type(row, number),
                            title:        row[:"title#{number}"],
                            initials:     row[:"initials#{number}"],
                            name:         row[:"name#{number}"] }
    end

    def assign_company entity, number, row
      name = "#{row[:"title#{number}"]} #{row[:"initials#{number}"]} " +
             "#{row[:"name#{number}"]}"
      entity.attributes = { entity_type:  entity_type(row, number),
                            title:        '',
                            initials:     '',
                            name:         name.strip }
    end

    def entity_type row, number
      person?(row, number) ? 'Person' : 'Company'
    end

    def person? row, number
      ( row[:"title#{number}"].present? || row[:"title#{number}"].present?) &&
        row[:"title#{number}"].exclude?('Ltd')
    end

    def clean_contact contactable
      clean_addresses contactable
      clean_entities contactable
    end

    def clean_addresses contactable
      addressable = contactable.address
      addressable.attributes =
        { town: addressable.town.titleize } if addressable.town.present?
    end

    def clean_entities contactable
      entitiable = contactable.entities
      if entity_title_starts_with_ampersand? entitiable[1]
        remove_ampersand_from_entity_title entitiable[1]
      end
    end

    def entity_title_starts_with_ampersand? entity
      entity && entity.title.present? && entity.title.starts_with?('& M')
    end

    def remove_ampersand_from_entity_title entity
      entity.title.sub!('& M', 'M')
    end
  end
end
