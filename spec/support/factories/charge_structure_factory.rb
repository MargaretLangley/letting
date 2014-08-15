require_relative 'charge_cycle_factory'
require_relative 'charged_in_factory'

def charge_structure_new **args
  base_charge_structure args
end

def charge_structure_create **args
  (structure = base_charge_structure args)
  structure.save!
  structure
end

private

def base_charge_structure **args
  charge_cycle = charge_cycle_create args.fetch(:charge_cycle_attributes, {})
  charged_in = charged_in_create args.fetch(:charged_in_attributes, {})
  charge_structure = ChargeStructure.new charge_structure_attributes \
    args.except(:due_on_attributes)
  charge_structure.charge_cycle = charge_cycle
  charge_structure.charged_in = charged_in
  charge_structure.due_ons.build due_on_attributes_0 \
    args.fetch(:due_on_attributes, {})
  charge_structure
end
