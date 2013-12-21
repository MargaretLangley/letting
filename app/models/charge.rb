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
  has_many :credits
  has_many :debits do
    def already_debited? debit
      self.any? do |debit|
      debit.already_charged? debit
      end
    end
  end

  after_initialize do
    self.start_date = Date.parse MIN_DATE if start_date.blank?
    self.end_date = Date.parse MAX_DATE if end_date.blank?
  end

  def chargeable_between? date_range
    due_between?(date_range) && !debited?(chargeable_info(date_range))
  end

  def next_chargeable date_range
    chargeable_between?(date_range) ? chargeable_info(date_range) : nil
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

  def due_between? date_range
    charge_range_covers?(date_range) && due_ons.between?(date_range)
  end

  def debited? chargeable
    debits.already_debited? Debit.new(chargeable.to_hash)
  end

  def charge_range_covers? date_range
    (start_date..end_date).cover?(date_range.min) &&
    (start_date..end_date).cover?(date_range.max)
  end

  def chargeable_info date_range
    ChargeableInfo
      .from_charge charge_id:  id,
                   on_date:    due_ons.date_between(date_range),
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
