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
  before_validation :clear_up_form
  attr_reader :source

  def account_dec
    @account_dec ||= AccountPaymentDecorator.new @source.account
  end

  def initialize payment
    @source = payment
  end

  def prepare_for_form
    if account_dec.source
      account_dec.prepare_for_form
      account_dec.credits_for_unpaid_debits.each do |credit|
        generate_credit credit
      end
    end
    @source.amount = outstanding if amount.blank?
  end

  def clear_up_form
    credits.each { |credit| credit.clear_up_form }
  end

  def submit_message
    @source.new_record? ?  'pay total'  : 'update'
  end

  def credits
    @credits = [] if @credits.nil?
    generate_credits if @credits.empty?
    @credits
  end

  def generate_credit credit
    @source.credits << credit.source
    @credits = []
  end

  private

  def generate_credits
    @credits.push(*@source.credits.map { |d| CreditDecorator.new d })
    @credits.each { |d| d.prepare_for_form }
    @credits
  end
end
