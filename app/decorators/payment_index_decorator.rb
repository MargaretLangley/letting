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
    @source.account.property.occupiers
  end

  def charge
  end

  def booked_on
    I18n.l @source.booked_on, format: :human
  end

  def amount
    number_to_currency @source.amount
  end

  def balance
    number_to_currency \
      @source.account.balance to_date: StringDate.new(booked_on).to_date
  end
end
