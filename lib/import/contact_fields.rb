require_relative '../modules/method_missing'
require_relative 'entity_fields'

# rubocop: disable Metrics/MethodLength

module DB
  ####
  #
  # ContactFields
  # Wraps around an imported row of data
  #
  # Called during the importing of any entity - property, agent
  # and client.
  #
  ####
  #
  class ContactFields
    include MethodMissing
    attr_reader :entities, :row

    def initialize row
      @row = row
      @entities = []
      @entities << EntityFields.new(row[:title1], row[:initials1], row[:name1])
      @entities << EntityFields.new(row[:title2], row[:initials2], row[:name2])
    end

    # contact values are overridden by row values
    #
    def update_for contact
      contact.entities.zip(entities).each do |entity, row|
        row.update_for entity
      end
      contact.address.attributes = address_attributes
    end

    private

    def address_attributes
      {
        flat_no:    row[:flat_no],
        house_name: row[:house_name],
        road_no:    row[:road_no],
        road:       row[:road],
        district:   row[:district],
        town:       town,
        county:     row[:county],
        postcode:   row[:postcode],
        nation:     row[:nation],
      }
    end

    def town
      return if row[:town].nil?
      row[:town].titleize
    end
  end
end
