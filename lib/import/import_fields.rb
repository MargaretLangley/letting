module DB
  class ImportFields

    def self.client
      %w{human_id } + entities + address
    end

    def self.property
      %w{human_id updated } + entities + address + %w{ client_id }
    end

    def self.billing_profile
      %w{ human_id } + entities + address
    end

    def self.charge
      %w{ human_id updated charge_type due_in amount payment_type } +
      %w{ day_1 month_1 day_2 month_2 day_3 month_3 day_4 month_4 } +
      %w{ escalation_date escaltion_new_rent }
    end

    def self.user
      %w{ email password admin }
    end

    private

      def self.entities
        %w{ title1  initials1 name1 title2 initials2 name2 }
      end

      def self.address
        %w{ flat_no  house_name road_no  road  district  town  county  postcode }
      end
  end
end
