def due_on_new id: nil, day:, month:, year: '', charge_cycle_id: nil
  DueOn.new id: id,
            day: day,
            month: month,
            year: year,
            charge_cycle_id: charge_cycle_id
end

def due_on_create id: nil, day:, month:, year: '', charge_cycle_id: nil
  due_on = due_on_new(id: id,
                      day: day,
                      month: month,
                      year: year,
                      charge_cycle_id: charge_cycle_id)
  due_on.save!
  due_on
end
