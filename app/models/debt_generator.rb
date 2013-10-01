class DebtGenerator < ActiveRecord::Base
  has_many :debts
  accepts_nested_attributes_for :debts
  scope :latest_debt_generated, ->(limit) { order(created_at: :desc).limit(limit) }

  after_initialize do |debt_generator|
    self.start_date = default_start_date if self.start_date.blank?
    self.end_date = default_end_date if self.end_date.blank?
  end

  def generate
    Property.search_min(self.search_string).each do |property|
      self.debts << property.account.generate_debts_for(start_date..end_date)
    end
    self.debts
  end

  def debtless?
    self.debts.empty?
  end

  def == another_debt_generator
    self.search_string == another_debt_generator.search_string && \
    self.start_date == another_debt_generator.start_date && \
    self.end_date == another_debt_generator.end_date
  end

  private

  def default_start_date
    Date.current
  end

  # You need to give a month's notice to bill for a charge (make a debt)
  # You don't want to bill into next months
  # Most printouts are done a month before.
  def default_end_date
    Date.current + 8.weeks
  end

end
