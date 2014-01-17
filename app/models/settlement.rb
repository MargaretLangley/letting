class Settlement < ActiveRecord::Base
  belongs_to :credit
  belongs_to :debit

  validates :credit_id, :debit_id, :amount, presence: true

  def self.resolve_credit sum, offsets
    settle = sum.outstanding
    offsets.each do |offset|
      settle -= pay = [settle, offset.outstanding].min
      break if pay.round(2) == 0.00
      sum.settlements.build debit: offset, amount: pay
    end
  end

  def self.resolve_debit sum, offsets
    settle = sum.outstanding
    offsets.each do |offset|
      settle -= pay = [settle, offset.outstanding].min
      break if pay.round(2) == 0.00
      sum.settlements.build credit: offset, amount: pay
    end
  end
end
