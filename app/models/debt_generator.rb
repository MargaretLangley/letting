class DebtGenerator < ActiveRecord::Base
  has_many :debts
  accepts_nested_attributes_for :debts
  scope :latest_debt_generated, ->(limit) { order(created_at: :desc).limit(limit) }

  def self.default_start_date
    Date.current
  end

  # You need to give a month's notice to bill for a charge (make a debt)
  # You don't want to bill into next months
  # Most printouts are done a month before.
  def self.default_end_date
    Date.current + 8.weeks
  end

  def == another_debt_generator
    self.search_string == another_debt_generator.search_string && \
    self.start_date == another_debt_generator.start_date && \
    self.end_date == another_debt_generator.end_date
  end

end
