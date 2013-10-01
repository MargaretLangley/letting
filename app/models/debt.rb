class Debt < ActiveRecord::Base
  belongs_to :account
  belongs_to :debt_generator
  has_many :payments
  belongs_to :charge

  validates :charge_id, :on_date, presence: true
  validates :amount, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

  def paid
    payments.pluck(:amount).inject(0, :+)
  end

  def paid?
    self.paid == amount
  end

  def already_charged another_debt
    self.charge_id == another_debt.charge_id && \
    self.on_date == another_debt.on_date
  end

  def eq? another_debt
    self.charge_id == another_debt.charge_id && \
    self.on_date == another_debt.on_date && \
    self.amount == another_debt.amount
  end

end
