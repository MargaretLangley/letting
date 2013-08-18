module Charges
  extend ActiveSupport::Concern
  included do
    has_many :charges, dependent: :destroy do
      def clean_up_form
        charges_for_destruction :empty?
      end
    private
      def charges_for_destruction matcher
        self.select(&matcher).each {|charge| mark_charge_for_destruction charge }
      end

      def mark_charge_for_destruction charge
        charge.mark_for_destruction
      end
    end
    accepts_nested_attributes_for :charges, allow_destroy: true
  end
  MAX_CHARGES = 1


private
  def prepare_charges
    (self.charges.size...MAX_CHARGES).each { self.charges.build }
  end
end
