class ChargeCycleDecorator
  def self.all
    ChargeCycle.all
               .order(order: :asc)
               .map { |charge_cycle| [charge_cycle.name, charge_cycle.id] }
  end
end
