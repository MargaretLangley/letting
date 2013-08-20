module Charges
  extend ActiveSupport::Concern
  included do
    has_many :charges, dependent: :destroy do
      def prepare
        (self.size...MAX_CHARGES).each do
          charge = self.build
          charge.prepare
        end
      end

      def clean_up_form
        destruction_if :empty?
      end
    private
      def destruction_if matcher
        self.select(&matcher).each {|charge| mark_charge_for_destruction charge }
      end

      def mark_charge_for_destruction charge
        charge.mark_for_destruction
      end
    end
  end
  MAX_CHARGES = 1
end
