def charge_new(charge_cycle: charge_cycle_new,
               charged_in:   charged_in_new,
               **args)
  charge = Charge.new charge_attributes args
  charge.charge_cycle = charge_cycle_new if charge_cycle_new
  charge
end

def charge_create(charge_cycle: charge_cycle_create,
                  charged_in:   charged_in_create,
                  **args)
  charge = Charge.new charge_attributes args
  charge.charge_cycle = charge_cycle if charge_cycle
  charge.save!
  charge
end
