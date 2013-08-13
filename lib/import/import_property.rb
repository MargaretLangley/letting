require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def do_it

      contents.each_with_index do |row, index|

        property = find_or_initialize_model row, Property
        property.prepare_for_form

        property.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
        property.billing_profile.use_profile = false if property.new_record?

        import_contact property, row
        clean_contact property

        output_error row, property unless property.save
        output_still_running index

      end
    end

    def address_type contactable
      contactable.human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
