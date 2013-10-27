####
#
# Charges
#
# Why does this class exist?
#
# Charges is an assocation that adds additional methods to
# it collection.
#
# How does this fit into the larger system
#
# Charges is an assocation found in an acount. An account has many charges.
#
# Account can query charges if it has a charge that become due within a date
# range. If it does it responds with a Chargeable_info that represents that
# charge to the account object.
#
# A charge can be queried to see if it becomes due within a date range.
#
# Charges also have prepare and clean_up_form which prepare for display on a
# form and handle the clean up after display, respectively.
####
#
module Charges
  extend ActiveSupport::Concern
  included do
    has_many :charges, dependent: :destroy do

      def chargeables_between date_range
        select { |charge| charge.due_between? date_range }
        .map { |charge| charge.chargeable_info date_range }
      end

      def prepare
        (size...MAX_CHARGES).each { build }
        each { |charge| charge.prepare }
      end

      def clean_up_form
        each { |charge| charge.clean_up_form }
      end
    end
  end
  MAX_CHARGES = 4
end
