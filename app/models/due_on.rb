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

  validates :year, numericality: { only_integer: true, greater_than: 1990,
                                    less_than: 2030 }, allow_nil: true
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

  def clear_up_form due_ons
    self.mark_for_destruction if empty?
    self.mark_for_destruction if due_ons.has_new_due_on? && self.persisted?
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  private

    def one_off_charge?
      year.present?
    end

    def ignored_attrs
      %w[id charge_id created_at updated_at]
    end

    def year_next_charge_is_due
      case
      when one_off_charge? then year
      when today_or_later_in_year? then Date.current.year
      else Date.current.year + 1
      end
    end

    def today_or_later_in_year?
      month_later_in_year? || today_or_later_in_this_month?
    end

    def month_later_in_year?
      month > Date.current.month
    end

    def today_or_later_in_this_month?
      month == Date.current.month && day >= Date.current.day
    end
end
