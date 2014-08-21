require_relative 'charge_cycle_factory'
require_relative 'charged_in_factory'
# rubocop: disable Style/MethodCallParentheses

def charge_structure_new **args
  base_charge_structure args
end

def charge_structure_create charged_in: charged_in_create(),
                            charge_cycle: nil, **args
  charge_structure = base_charge_structure(charged_in: charged_in, **args)
  charge_structure.charge_cycle = charge_cycle if charge_cycle
  charge_structure.save!
  charge_structure
end

private

def base_charge_structure(charged_in: nil, **args)
  charge_structure = ChargeStructure.new args.except(:due_on_attributes)
  charge_structure.charge_cycle = \
    charge_cycle_create args.fetch(:charge_cycle_attributes, {})
  if charged_in
    charge_structure.charged_in = charged_in
  else
    charge_structure.charged_in = \
      charged_in_create args.fetch(:charged_in_attributes, {})
  end
  charge_structure
end
