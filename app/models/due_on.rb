class DueOn < ActiveRecord::Base
  belongs_to :charge
  validates :day, :month, presence: true
  validates :day, numericality: { only_integer: true, greater_than: 0,
                                  less_than: 32 }
  validates :month, numericality: { only_integer: true, greater_than: -2,
                                    less_than: 13 }
  PER_MONTH = -1
  ON_DATE = 0

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  def per_month?
    month == PER_MONTH
  end

  def between? date_range
    date_range.cover? make_date
  end

  def make_date
    Date.new covered_year, month, day
  end

  private

    def ignored_attrs
      %w[id charge_id created_at updated_at]
    end

    def covered_year
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
