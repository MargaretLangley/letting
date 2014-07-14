require_relative '../modules/method_missing'
require_relative 'errors'

module DB
  ####
  #
  # PropertyRow
  #
  # Used by ImportProperty to encapsulates a csv row.
  #
  # CSV rows are presented as arrays indexed by symbols - example 'client_ref'
  # PropertyRow provides an interface to ImportProperty for these CSV rows.
  # ImportProperty is then only concerned with building and assigning Property
  # classes and not how to get this information.
  #
  ####
  #
  class PropertyRow
    include MethodMissing

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref].to_i
    end

    def client_id
      client_ref_to_id
    end

    private

    def client_ref
      @source[:client_ref]
    end

    def client_ref_to_id
      Client.find_by!(human_ref: client_ref).id
      rescue ActiveRecord::RecordNotFound
        raise ClientRefUnknown, client_ref_unknown_msg, caller
    end

    def client_ref_unknown_msg
      "Client ref: #{client_ref} is unknown."
    end
  end
end
