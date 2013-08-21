module Charges
  extend ActiveSupport::Concern
  included do
    has_many :charges, dependent: :destroy do
      def prepare
        (self.size...MAX_CHARGES).each do
          charge = self.build
        end
        self.each {|charge| charge.prepare }
      end

      def clean_up_form
        self.each {|charge| charge.clean_up_form }
        destruction_if :empty?
      end

      def first_or_initialize charge_type
        self.detect{|charge| charge.charge_type == charge_type } || self.build
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
  MAX_CHARGES = 4
end
