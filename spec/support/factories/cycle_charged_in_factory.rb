def cycle_charged_in_create(id:, cycle_id:, charged_in_id:)
  CycleChargedIn.create! id: id,
                         cycle_id: cycle_id,
                         charged_in_id: charged_in_id
end
