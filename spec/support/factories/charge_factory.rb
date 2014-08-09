def charge_new **args
  charge = Charge.new charge_attributes args
  charge.build_charge_structure charge_structure_attributes
  charge.charge_structure.due_ons.build due_on_attributes_0
  charge.charge_structure.due_ons.build due_on_attributes_1
  charge
end
