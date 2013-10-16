class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :debt

  validates :debt_id, :on_date, :payment_id, presence: true
  validates :amount, amount: true

  def self.search(search)
    @accounts = Accounts.find_by_property_id params[:property]
  end

end
