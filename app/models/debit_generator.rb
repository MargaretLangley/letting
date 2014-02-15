####
#
# DebitGenerator
#
# Why does the class exist?
#
# To search a group of properties for charges that are due and generate
# the debits.
#
# How does it fit into the larger system?
#
# Coverts due charges into debits. The debits are then used for invoicing
# owing debits and later credits through payments.
#
####
#
class DebitGenerator < ActiveRecord::Base
  has_many :debits, -> { uniq }, dependent: :destroy
  attr_accessor :accounts
  validates :search_string, uniqueness: { scope: [:start_date, :end_date] },
                            presence: true
  validates :accounts, :debits, :end_date, :start_date, presence: true
  validates_with DateEqualOrAfter
  accepts_nested_attributes_for :debits

  scope :latest_debit_generated,
        ->(limit) { order(created_at: :desc).limit(limit) }

  after_initialize do
    self.start_date = default_start_date if start_date.blank?
    self.end_date = default_end_date if end_date.blank?
  end

  def generate
    accounts.each do |account|
      debits.push *(account.prepare_debits start_date..end_date)
    end
  end

  def debitless?
    debits.empty?
  end

  def == other
    search_string == other.search_string &&
    start_date == other.start_date &&
    end_date == other.end_date
  end

  private

  # REALLY like this to be a search object. Don't see why search
  # has to be tied to property.
  def accounts
    @accounts ||= Property.search_min(search_string).map(&:account)
  end

  def default_start_date
    Date.current
  end

  # You need to give a month's notice to bill for a charge (make a debit)
  # You don't want to bill into next months
  # Most printouts are done a month before.
  def default_end_date
    Date.current + 8.weeks
  end
end
