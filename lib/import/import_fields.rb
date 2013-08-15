module DB
  class ImportFields

    def self.client
      %w{human_id } + self.entities + self.address
    end

    def self.property
      %w{human_id updated } + self.entities + self.address
    end

    def self.billing_profile
      %w{ human_id } + self.entities + self.address
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
