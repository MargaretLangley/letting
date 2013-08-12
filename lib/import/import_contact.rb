module DB
  module ImportContact
    extend ActiveSupport::Concern

      module ClassMethods

        def address addressable, args = {}

          addressable.attributes = {  type:       args[:type],
                                      flat_no:    args[:flat_no],
                                      house_name: args[:house_name],
                                      road_no:    args[:road_no],
                                      road:       args[:road],
                                      district:   args[:district],
                                      town:       args[:town],
                                      county:     args[:county],
                                      postcode:   args[:postcode] }
        end


        def entity entity, args = {}
          entity.attributes = { title:    args[:title],
                                initials: args[:initials],
                                name:     args[:name] }
        end
      end
  end
end