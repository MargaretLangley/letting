require_relative '../modules/method_missing'
require_relative 'errors'

module DB
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
