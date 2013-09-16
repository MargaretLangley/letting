class AccountEntry < ActiveRecord::Base

  validates :charge_id, :on_date, presence: true
  validates :paid, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

  def payment payment
    self.charge_id = payment.charge_id
    self.paid = payment.amount
    self.on_date = payment.on_date
    self.due = 0
  end

end
