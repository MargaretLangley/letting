def charge_cycle_new **args
  cycle = ChargeCycle.new charge_cycle_attributes \
                          args.except(:due_on_attributes)
  cycle.due_ons.build due_on_attributes_0 args.fetch(:due_on_attributes, {})
  cycle
end

def charge_cycle_create due_on: due_on, **args
  cycle = ChargeCycle.new charge_cycle_attributes args
    .except(:due_on_attributes)
  if due_on
    cycle.due_ons << due_on
  else
    cycle.due_ons.build due_on_attributes_0 args.fetch(:due_on_attributes, {})
  end
  cycle.save!
  cycle
end
