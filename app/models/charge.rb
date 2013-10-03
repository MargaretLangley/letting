class Charge < ActiveRecord::Base
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  belongs_to :property
  validates :amount, :charge_type, :due_in, presence: true
  validates :due_ons, presence: true
  validate :due_ons_size
  has_many :debt

  def due_between? date_range
    due_ons.between? date_range
  end

  def chargeable_info date_range
    ChargeableInfo.from_charge charge_id: id, \
                         on_date: due_ons.make_date_between(date_range), \
                         amount: amount, \
                         account_id: account_id
  end

  def prepare
    due_ons.prepare
  end

  def clean_up_form
    due_ons.clean_up_form
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?) \
    && due_ons.empty?
  end

  def due_ons_size
    errors.add :due_ons, 'Too many due_ons' if due_ons.reject(&:marked_for_destruction?).size > 12
  end

  private

    def ignored_attrs
      %w[ id account_id created_at updated_at ]
    end

end
