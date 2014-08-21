require_relative 'charge_cycle_factory'
require_relative 'charged_in_factory'
# rubocop: disable Style/MethodCallParentheses

def charge_structure_new **args
  base_charge_structure args
end

def charge_structure_create charged_in: charged_in_create(),
                            charge_cycle: nil, **args
  structure = base_charge_structure(charged_in: charged_in,
                                    **(charge_structure_attributes args))
  structure.charge_cycle = charge_cycle if charge_cycle
  structure.save!
  structure
end

private

def base_charge_structure(charged_in: nil, **args)
  structure = ChargeStructure.new args.except(:due_on_attributes)
  structure.charge_cycle = \
    charge_cycle_create args.fetch(:charge_cycle_attributes, {})
  if charged_in
    structure.charged_in = charged_in
  else
    structure.charged_in = \
      charged_in_create args.fetch(:charged_in_attributes, {})
  end
  structure
end
