class DueOn < ActiveRecord::Base
  belongs_to :charge
  validates :day, :month, presence: true
  validates :day, numericality: { only_integer: true, greater_than: 0, less_than: 32 }
  validates :month, numericality: { only_integer: true, greater_than: -2, less_than: 13 }

  PER_MONTH = -1

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? ) #\
  end

  def per_month?
    month == PER_MONTH
  end

  private
    def ignored_attrs
      ['id','charge_id', 'created_at', 'updated_at']
    end
end
