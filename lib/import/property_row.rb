require_relative 'errors'

module DB
  class PropertyRow
    def initialize row
      @row = row
    end

    def human_ref
      @row[:human_ref].to_i
    end

    def client_id
      client_ref_to_id client_ref
    end

    def method_missing method_name, *args, &block
      @row.send method_name, *args, &block
    end

    def respond_to_missing? method_name, include_private = false
      @row.respond_to?(method_name, include_private) || super
    end

    private

    def client_ref
      @row[:client_ref]
    end

    def client_ref_to_id human_ref
      Client.find_by!(human_ref: client_ref).id
      rescue ActiveRecord::RecordNotFound
        raise ClientRefUnknown, client_ref_unknown_msg, caller
    end

    def client_ref_unknown_msg
      "Client ref: #{client_ref} is unknown."
    end
  end
end
