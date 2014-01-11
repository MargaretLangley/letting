class Settlement < ActiveRecord::Base
  belongs_to :credit
  belongs_to :debit

  validates :credit_id, :debit_id, :amount, presence: true

  def self.resolve_credit credit, debits
    cover = credit.spendable
    debits.each do |debit|
      cover -= pay = [cover, debit.outstanding].min
      break if pay.round(2) == 0.00
      credit.settlements.build debit: debit, amount: pay
    end
  end

  def self.resolve_debit debit, credits
    owe = debit.outstanding
    credits.each do |credit|
      owe -= pay = [owe, credit.spendable].min
      break if pay.round(2) == 0.00
      debit.settlements.build credit: credit, amount: pay
    end
  end
end
