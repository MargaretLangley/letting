####
#
# A charge that is applied to a property's account.
#
# A charge represents the type, amount and, through due_ons, the date that
# a property should become due a charge.
#
# The code is part of the charge system in the accounts. Charges are
# associated with a properties account. When an operator decides they want to
# bill a group of properties. Charges are generated according to this
# information using the debit generator. The information is passed, as a
# chargeable, to becomes a debit in the properties account.
#
####
#
class Charge < ActiveRecord::Base
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  belongs_to :account
  validates :charge_type, :due_in, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than: 100_000 }
  validates :due_ons, presence: true
  has_many :debits, dependent: :destroy do
    def created_on? on_date
      self.any? do |debit|
      debit.on_date == on_date
      end
    end
  end

  after_initialize do
    self.start_date = Date.parse MIN_DATE if start_date.blank?
    self.end_date = Date.parse MAX_DATE if end_date.blank?
  end

  def next_chargeable date_range
    allowed_due_dates(date_range).map do |my_date|
      chargeable_info(my_date) if !debits.created_on? my_date
    end.compact
  end

  def prepare
    due_ons.prepare
  end

  def clear_up_form
    mark_for_destruction unless edited?
    due_ons.clear_up_form
  end

  private

  def edited?
    !empty?
  end

  def allowed_due_dates date_range
    due_ons.due_dates(date_range).to_a & (start_date..end_date).to_a
  end

  def chargeable_info date
    ChargeableInfo
      .from_charge charge_id:  id,
                   on_date:    date,
                   amount:     amount,
                   account_id: account_id
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?) &&
    start_date == Date.parse(MIN_DATE) &&
    end_date == Date.parse(MAX_DATE) &&
    due_ons.empty?
  end

  def ignored_attrs
    %w[id account_id start_date end_date created_at updated_at]
  end
end
