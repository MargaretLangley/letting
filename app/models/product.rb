class Product < ActiveRecord::Base
  include Comparable

  def <=> other
    return nil unless other.is_a?(self.class)
    [charge_type, date_due, amount, range] <=>
      [other.charge_type, other.date_due, other.amount, range]
  end
end
