def charge_cycle_new name: 'Mar/Sep',
                     order: 1,
                     due_ons: [DueOn.new(day: 25, month: 3)],
                     prepare: false
  cycle = ChargeCycle.new name: name, order: order
  cycle.due_ons = due_ons if due_ons
  cycle.prepare if prepare
  cycle
end

def charge_cycle_create id: 1,
                        name: 'Mar/Sep',
                        order: 1,
                        due_ons: [DueOn.new(day: 25, month: 3)],
                        prepare: false
  cycle = ChargeCycle.new id: id, name: name, order: order
  cycle.due_ons = due_ons if due_ons
  cycle.prepare if prepare
  cycle.save!
  cycle
end

def charge_cycle_name(id:)
  ChargeCycle.find(id).name
end
