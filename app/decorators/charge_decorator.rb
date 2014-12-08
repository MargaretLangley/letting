###
# ChargeDecorator
#
# Adds display logic to the charge business object.
# rubocop: disable  Style/TrivialAccessors
##
#
class ChargeDecorator
  include MethodMissing
  def charge
    @source
  end

  def initialize charge
    @source = charge
  end

  # Charges that are dormant should appear different from active charges.
  # This changes the style class for dormant charges.
  #
  def emphasis
    charge.dormant? ? 'deemphasized' : ''
  end

  # If the charge is active or dormant
  # Active charges are generating new debts, dormant charges do not.
  #
  def dormant
    charge.dormant? ? 'Yes' : 'No'
  end

  # If payments happen without requiring an invoice reminder.
  #
  #
  def pay
    automatic_payment? ? 'Automatic' : 'Payment'
  end
end
