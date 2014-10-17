###
# CycleDecorator
#
# Adds display logic to the charge cycle business object.
##
#
class CycleDecorator
  def self.all
    Cycle.all
               .order(order: :asc)
               .map { |cycle| [cycle.name, cycle.id] }
  end
end
