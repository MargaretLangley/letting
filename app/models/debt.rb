class Debt < ActiveRecord::Base
  belongs_to :account

  validates :charge_id, :on_date, presence: true
  validates :amount, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

end
