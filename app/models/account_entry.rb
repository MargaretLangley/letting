class AccountEntry < ActiveRecord::Base
  belongs_to :account

  validates :charge_id, :on_date, presence: true
  validates :paid, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

  scope :latest_payments, ->(limit) { where('paid > 0').order(created_at: :desc).limit(limit) }

  def debt debt
    self.charge_id = debt.charge_id
    self.on_date = debt.on_date
    self.amount = debt.amount
    self
  end

end
