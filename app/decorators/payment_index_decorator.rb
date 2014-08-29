#######
#
# PaymentIndexDecorator
#
# Adds display logic to payment business object.
#
class PaymentIndexDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActionView::Helpers::NumberHelper

  attr_reader :source

  def initialize payment
    @source = payment
  end

  def property_ref
    @source.account.property.human_ref
  end

  def full_name
    @source.account.property.occupier
  end

  def charge
  end

  def on_date
    I18n.l @source.on_date, format: :human
  end

  def amount
    number_to_currency @source.amount
  end

  def balance
    number_to_currency @source.account.balance StringDate.new(on_date).to_date
  end
end
