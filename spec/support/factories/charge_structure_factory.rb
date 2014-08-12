
def charge_structure_new **args
  base_charge_structure args
end

def charge_structure_create **args
  (structure = base_charge_structure args).save!
  structure
end

private

def base_charge_structure **args
  charge_structure = ChargeStructure.new charge_structure_attributes \
    args.except(:due_on_attributes)
  # charge_structure.prefer_for_form
  charge_structure.due_ons.build due_on_attributes_0 \
    args.fetch(:due_on_attributes, {})
  charge_structure
end
