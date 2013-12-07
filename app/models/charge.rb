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
  validate :due_ons_size
  has_many :credits
  has_many :debits do
    def already_debited? debit
      # any? returns true if a collection element does not return false or nil
      self.any? do |debit|
      debit.already_charged? debit
      end
    end
  end

  after_initialize do
    self.start_date = Date.parse MIN_DATE if start_date.blank?
    self.end_date = Date.parse MAX_DATE if end_date.blank?
  end

  def first_chargeable date_range
    first_chargeable?(date_range) ? chargeable_info(date_range) : nil
  end

  def first_free_chargeable? date_range
    first_chargeable?(date_range) &&
      !already_charged_for?(chargeable_info(date_range))
  end

  def first_free_chargeable date_range
    first_free_chargeable?(date_range) ? chargeable_info(date_range) : nil
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

  def first_chargeable? date_range
    due_between?(date_range)
  end

  def due_between? date_range
    charge_range_dates_cover?(date_range) && due_ons.between?(date_range)
  end

  def already_charged_for? chargeable
    debits.already_debited? Debit.new(chargeable.to_hash)
  end

  def charge_range_dates_cover? date_range
    charge_range.cover?(date_range.min) && charge_range.cover?(date_range.max)
  end

  def chargeable_info date_range
    ChargeableInfo
      .from_charge charge_id:  id,
                   on_date:    due_ons.make_date_between(date_range),
                   amount:     amount,
                   account_id: account_id
  end

  def charge_range
    start_date .. end_date
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

  def due_ons_size
    errors.add :due_ons, 'Too many due_ons' if persitable_due_ons.size > 12
  end

  def persitable_due_ons
    due_ons.reject(&:marked_for_destruction?)
  end
end
