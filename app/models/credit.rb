class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :debt

  validates :debt_id, :on_date, :payment_id, presence: true
  validates :amount, amount: true

  after_initialize do |debt_generator|
    self.on_date = default_on_date if on_date.blank?
    self.amount = default_amount if amount.blank?
  end

  def self.search(search)
    @accounts = Accounts.find_by_property_id params[:property]
  end

  def default_amount
    debt.amount
  end

  private

  def default_on_date
    Date.current
  end


end
