####
#
# AccountDebit
#
# Debits due on an account - structure used for display in a view page
#
####
#
class AccountDebit
  include Comparable
  attr_reader :amount, :date_due, :charge_type, :property_ref
  def initialize(date_due:, charge_type:, property_ref:, amount:)
    @date_due = date_due
    @charge_type = charge_type
    @property_ref = property_ref
    @amount = amount
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [date_due, charge_type, property_ref] <=>
      [other.date_due, other.charge_type, other.property_ref]
  end
end
