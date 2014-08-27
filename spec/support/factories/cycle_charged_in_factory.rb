def cycle_charged_in_create(id:, charge_cycle_id:, charged_in_id:)
  CycleChargedIn.create! id: id,
                         charge_cycle_id: charge_cycle_id,
                         charged_in_id: charged_in_id
end
