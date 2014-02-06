require_relative 'contact_row'

module DB
  ####
  #
  # ImportContact
  #
  # Shared code for the importing of contact data (entities + address)
  #
  # Contact data is used on Property, agent and Client data
  # This is used during the import of these model's data.
  #
  ####
  #
  module ImportContact
    extend ActiveSupport::Concern

    def import_contact contactable, row
      row = ContactRow.new row
      contactable.entities.zip(row.entities).each do |entity1, entity2|
        entity1.attributes = entity2.attributes
      end
      contactable.address.attributes = row.address_attributes
    end
  end
end
