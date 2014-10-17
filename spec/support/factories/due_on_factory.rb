def due_on_new id: nil, day: 25, month: 3, year: '', cycle_id: nil
  DueOn.new id: id,
            day: day,
            month: month,
            year: year,
            cycle_id: cycle_id
end

def due_on_create id: nil, day: 25, month: 3, year: '', cycle_id: nil
  due_on = due_on_new(id: id,
                      day: day,
                      month: month,
                      year: year,
                      cycle_id: cycle_id)
  due_on.save!
  due_on
end
