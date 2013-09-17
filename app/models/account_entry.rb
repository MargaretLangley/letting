class AccountEntry < ActiveRecord::Base
  belongs_to :account

  validates :charge_id, :on_date, presence: true
  validates :paid, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

  scope :latest_payments, ->(limit) { where('paid > 0').order(created_at: :desc).limit(limit) }

  def debt debt
    self.charge_id = debt.charge_id
    self.paid = 0
    self.on_date = debt.on_date
    self.due = debt.amount
    self
  end

  def payment payment
    self.charge_id = payment.charge_id
    self.paid = payment.amount
    self.on_date = payment.on_date
    self.due = 0
    self
  end

end
