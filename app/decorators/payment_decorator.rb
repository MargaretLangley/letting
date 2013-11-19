require_relative '../../lib/modules/method_missing'
####
#
# PropertyDecorator
#
# Adds behavior to the payment object
#
# Used when the payment has need for behviour outside of the core
# of the model. Specifically for display information.
#
####
#
class PaymentDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  attr_reader :source

  def initialize payment
    @source = payment
  end

  def prepare_for_form
    if @source.account_exists?
      @source.prepare
      @source.amount = outstanding if amount.blank?
    end
  end

  def credits_with_debits
    credits.reject &:advance?
  end

  def credits_in_advance
    credits.select &:advance?
  end

  def property_decorator
    PropertyDecorator.new @source.account.property
  end

  def submit_message
    @source.new_record? ?  'pay total'  : 'update'
  end

  def show_advanced?
    credits_with_debits.present?
  end

  private

  def credits
    @credits = [] if @credits.nil?
    generate_credits if @credits.empty?
    @credits
  end

  def generate_credits
    @credits.push(*@source.credits.reject(&:advance?).map { |d| CreditWithDebitDecorator.new d })
    @credits.push(*@source.credits.select(&:advance?).map { |d| CreditInAdvanceDecorator.new d })
    @credits.each { |d| d.prepare_for_form }
    @credits
  end
end
