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
# Converts due charges into debits. The debits are then used for invoicing
# owing debits and later credits through payments.
#
####
#
class DebitGenerator < ActiveRecord::Base
  include Comparable
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

  def generate accounts: accounts(query: search_string)
    accounts.each do |account|
      debits.push(*account.make_debits(start_date..end_date))
    end
  end

  def debitless?
    debits.empty?
  end

  # simple value equality - (not sure if that's what I need)
  def <=> other
    return nil unless other.is_a?(self.class)
    [search_string, start_date, end_date] <=>
      [other.search_string, other.start_date, other.end_date]
  end

  # search_string - property, human, ref 1098 or range of the form
  #                 1098 - 2000
  def accounts query: search_string
    @accounts ||= Account.between?(query)
  end

  private

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
