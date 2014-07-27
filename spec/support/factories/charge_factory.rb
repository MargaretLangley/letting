def charge_new **args
  charge = Charge.new charge_attributes args
  charge.due_ons.build due_on_attributes_0
  charge.due_ons.build due_on_attributes_1
  charge
end
