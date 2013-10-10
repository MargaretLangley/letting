####
#
# ChargesMatcher
#
# Matching only required during the import process
#
# This is a service object for Charge it allows a charge to match
# an imported charge. Matching import charges should not be the concern
# of the Charge object. The import process will happen only a few times
# and then migration is complete to the system retired.
#
####
#
class ChargesMatcher

  def initialize charges
    @charges = charges
  end

  def first_or_initialize charge_type
    @charges.find { |charge| charge.charge_type == charge_type } ||
      @charges.build
  end

end
