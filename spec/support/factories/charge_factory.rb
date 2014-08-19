def charge_new **args
  Charge.new charge_attributes args
end

def charge_create charge_structure: charge_structure_create, **args
  charge = Charge.new charge_attributes args
  charge.charge_structure = charge_structure if charge_structure
  charge.save!
  charge
end
