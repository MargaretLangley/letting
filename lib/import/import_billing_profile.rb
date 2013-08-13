require_relative 'import_contact'

module DB
  class ImportBillingProfile
    include ImportContact
    attr_reader :contents

    def initialize contents
      @contents = contents
    end

    def self.import contents
      new(contents).do_it
    end

    def do_it

      contents.each_with_index do |row, index|

        property = Property.where(human_id: row[:human_id]).first_or_initialize
        billing_profile = property.billing_profile
        billing_profile.prepare_for_form property
        billing_profile.assign_attributes use_profile: true
        import_contact billing_profile, row

        # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0

        clean_contact billing_profile

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
