class Settlement < ActiveRecord::Base
  belongs_to :credit
  belongs_to :debit

  validates :credit_id, :debit_id, :amount, presence: true

  def self.resolve_credit credit, debits
    owe = credit.amount
    debits.each do |debit|
      owe -= pay = [owe, debit.amount].min
      credit.settlements.build debit: debit, amount: pay
    end
  end

  def self.resolve_debit debit, credits
    owe = debit.amount
    credits.each do |credit|
      owe -= pay = [owe, credit.amount].min
      debit.settlements.build credit: credit, amount: pay
    end
  end
end
