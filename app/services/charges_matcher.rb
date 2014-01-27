require_relative '../../lib/import/errors'
####
#
# ChargesMatcher
#
# Matching only needed during the import process
#
# This is a service object for Charges it allows a charge to match
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
    find(charge_type) || @charges.build
  end

  def find! charge_type
    charge = find charge_type
    fail DB::ChargeUnknown, error_msg(charge_type), caller if charge.nil?
    charge
  end

  def find charge_type
    @charges.find { |charge| charge.charge_type == charge_type }
  end

  def error_msg charge_type
    "Charge '#{charge_type}' not found in property " +
    "'#{property_ref || 'unknown' }'"
  end

  def property_ref
    @charges.first.try(:account).try(:property).try(:human_ref)
  end
end
