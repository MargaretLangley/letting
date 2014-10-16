# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/ParameterLists

def charge_cycle_new id: nil,
                     name: 'Mar/Sep',
                     order: 1,
                     cycle_type: 'term',
                     due_ons: [DueOn.new(day: 25, month: 3)],
                     prepare: false
  cycle = ChargeCycle.new id: id,
                          name: name,
                          order: order,
                          cycle_type: cycle_type
  cycle.due_ons = due_ons if due_ons
  cycle.prepare if prepare
  cycle
end

def charge_cycle_create id: 1,
                        name: 'Mar/Sep',
                        order: 1,
                        cycle_type: 'term',
                        due_ons: [DueOn.new(day: 25, month: 3)],
                        prepare: false
  cycle = charge_cycle_new id: id,
                           name: name,
                           order: order,
                           cycle_type: cycle_type,
                           due_ons: due_ons,
                           prepare: prepare
  cycle.save!
  cycle
end

def charge_cycle_monthly_create id: 1,
                        name: 'First',
                        order: 1,
                        cycle_type: 'monthly',
                        day: 1,
                        prepare: false
  cycle = ChargeCycle.new id: id,
                          name: name,
                          order: order,
                          cycle_type: cycle_type
  (1..12).each { |month| cycle.due_ons << [DueOn.new(day: day, month: month)] }
  cycle.prepare if prepare
  cycle.save!
  cycle
end

def charge_cycle_name(id:)
  ChargeCycle.find(id).name
end
