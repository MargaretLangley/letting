###
# ChargeDecorator
#
# Adds display logic to the charge business object.
##
#
class ChargeDecorator
  include MethodMissing
  attr_reader :source

  def initialize charge
    @source = charge
  end

  def style_emphasis
    @source.dormant? ? 'dormant' : ''
  end

  def dormant
    @source.dormant? ? 'Yes' : 'No'
  end
end
