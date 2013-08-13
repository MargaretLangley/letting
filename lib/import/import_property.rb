require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def do_it

      contents.each_with_index do |row, index|

        property = Property.where(human_id: row[:human_id]).first_or_initialize
        property.prepare_for_form

        property.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
        property.billing_profile.use_profile = false if property.new_record?

        import_contact property, row
        clean_contact property

        still_running index

        unless property.save
          puts "human propertyid: #{row[:human_id]} -  #{property.errors.full_messages}"
        end

      end
    end

    def address_type contactable
      contactable.human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
