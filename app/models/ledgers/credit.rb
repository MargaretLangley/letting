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
# Credits decrease an accounts balance -.
####
#
class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :charge, inverse_of: :credits
  has_many :debits, through: :settlements
  has_many :settlements, dependent: :destroy

  validates :charge, :on_date, presence: true
  validates :amount, price_bound: true
  after_initialize :init
  before_save :reconcile

  def init
    self.on_date = Time.zone.today if on_date.blank?
  end

  delegate :charge_type, to: :charge

  def clear_up
    mark_for_destruction if amount.nil? || amount.round(2).zero?
  end

  # outstanding is the amount left unpaid
  # (credit) amount is normally negative
  # settled starts at 0 and becomes larger until settled - amount == 0
  # Outstanding will be initially negative trending to 0
  def outstanding
    -amount - settled
  end

  def spent?
    outstanding.round(2).zero?
  end

  scope :total, -> { sum(:amount)  }
  scope :before, -> (until_date) { where('? >= on_date', until_date) }

  def self.available charge_id
    where(charge_id: charge_id).order(:on_date).reject(&:spent?)
  end

  private

  # Called on save to see if a debit can be matched to a credit
  #
  def reconcile
    Settlement.resolve(outstanding, Debit.available(charge_id)) do |offset, pay|
      settlements.build debit: offset, amount: pay
    end
  end

  def settled
    settlements.pluck(:amount).inject(0, :+)
  end
end
