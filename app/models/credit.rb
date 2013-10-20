class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :debit

  validates :debit_id, :on_date, presence: true
  validates :amount, amount: true

  after_initialize do |debit_generator|
    self.on_date = default_on_date if on_date.blank?
    self.amount = default_amount if amount.blank?
  end

  def self.search(search)
    @accounts = Accounts.find_by_property_id params[:property]
  end

  def default_amount
    debit.amount
  end

  private

  def default_on_date
    Date.current
  end

end
