def charge_new(charge_cycle: charge_cycle_new,
               charged_in:   charged_in_new,
               **args)
  base_charge charge_cycle: charge_cycle, charged_in: charged_in, **args
end

def charge_create(charge_cycle: charge_cycle_create,
                  charged_in:   charged_in_create,
                  **args)
  charge = base_charge charge_cycle: charge_cycle,
                       charged_in: charged_in,
                       **args
  charge.save!
  charge
end

def base_charge(charge_cycle:, charged_in:, **args)
  charge = Charge.new charge_attributes args
  charge.charge_cycle = charge_cycle if charge_cycle
  charge.charged_in = charged_in if charged_in
  charge
end
