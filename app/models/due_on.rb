####
#
# The day and month during the year to charge a property.
#
# Charges will become due every year into the future. By holding a
# day and month a charge is due we can handle recurring charges.
#
# The code is part of the charge system in the accounts.
#
# The class models charges by either being:
# ON_DATE: holding a day and month or by holding.
# PER_MONTH: a day and have it reoccur every month.
#
####
#
class DueOn < ActiveRecord::Base
  belongs_to :charge
  validates :day, :month, presence: true
  validates :day,   numericality: { only_integer: true, greater_than: 0,
                                    less_than: 32 }
  validates :month, numericality: { only_integer: true, greater_than: -2,
                                    less_than: 13 }
  PER_MONTH = -1
  ON_DATE = 0

  def per_month?
    month == PER_MONTH
  end

  def between? date_range
    date_range.cover? make_date
  end

  def make_date
    Date.new year_next_charge_is_due, month, day
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  private

    def ignored_attrs
      %w[id charge_id created_at updated_at]
    end

    def year_next_charge_is_due
      due_this_year? ? Date.current.year : Date.current.year + 1
    end

    def due_this_year?
      case
      when month > Date.current.month
        true
      when month == Date.current.month && day >= Date.current.day
        true
      else
        false
      end
    end
end
