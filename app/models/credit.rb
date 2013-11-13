####
#
# Credit
#
# Generated by payments and linked to a debit. The credit offsets
# a debit charged to a property account.
#
#
# A payment is applied to one property account. When being applied
# it finds unpaid debits and generates a matching credit.
# The credits get set during the payments controller #create action.
#
####
#
class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :debit

  validates :on_date, presence: true
  validates :amount, amount: true
  validates :amount, numericality:
                     { less_than_or_equal_to: ->(credit) { credit.pay_off_debit } }

  after_initialize do
    self.on_date = default_on_date if on_date.blank?
    @original_amount = amount
  end

  #
  # The amount outstanding on the debit associated with this credit
  #
  def pay_off_debit
    new_record? ? debit_outstanding : update_pay_off
  end

  def clear_up
    self.mark_for_destruction if amount.nil? || amount.round(2) == 0
  end

  private

  def update_pay_off
    debit_outstanding + @original_amount
  end

  def debit_outstanding
    debit.outstanding
  end

  def default_on_date
    Date.current
  end
end
