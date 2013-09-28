# Matching only required during the import process

class ChargesMatcher

  def initialize charges
    @charges = charges
  end

  def first_or_initialize charge_type
    @charges.detect{|charge| charge.charge_type == charge_type } || @charges.build
  end

end