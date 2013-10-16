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
# information using the debt generator. The information is passed, as a
# chargeable, to becomes a debt in the properties account.
#
####
#
class Charge < ActiveRecord::Base
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  belongs_to :account
  validates :charge_type, :due_in, presence: true
  validates :amount, amount: true
  validates :due_ons, presence: true
  validate :due_ons_size
  has_many :debt

  def due_between? date_range
    due_ons.between? date_range
  end

  def chargeable_info date_range
    ChargeableInfo
    .from_charge charge_id:  id,
                 on_date:    due_ons.make_date_between(date_range),
                 amount:     amount,
                 account_id: account_id
  end

  def prepare
    due_ons.prepare
  end

  def clean_up_form
    due_ons.clean_up_form
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?) &&
      due_ons.empty?
  end

  def due_ons_size
    errors.add :due_ons, 'Too many due_ons' if persitable_due_ons.size > 12
  end

  private

    def ignored_attrs
      %w[id account_id created_at updated_at]
    end

    def persitable_due_ons
      due_ons.reject(&:marked_for_destruction?)
    end

end
