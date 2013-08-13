require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportBillingProfile < ImportBase

    def do_it

      contents.each_with_index do |row, index|

        property = Property.where(human_id: row[:human_id]).first_or_initialize
        billing_profile = property.billing_profile
        billing_profile.prepare_for_form property

        billing_profile.assign_attributes use_profile: true

        import_contact billing_profile, row
        clean_contact billing_profile

        output_still_running index

        unless billing_profile.save
          puts "human propertyid: #{row[:propertyid]} -  #{billing_profile.errors.full_messages}"
        end
      end
    end

    def address_type contactable
      contactable.property.human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
