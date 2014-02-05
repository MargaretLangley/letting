require_relative '../modules/method_missing'
require_relative 'errors'
require_relative 'entity_row'

module DB

  class ContactRow
    include MethodMissing
    attr_reader :entities

    def initialize row
      @source = row
      @entities = []
      @entities << EntityRow.new(row[:title1], row[:initials1], row[:name1])
      @entities << EntityRow.new(row[:title2], row[:initials2], row[:name2])
    end
  end
end
