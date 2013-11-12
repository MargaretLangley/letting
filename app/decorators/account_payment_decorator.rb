require_relative '../../lib/modules/method_missing'

class AccountPaymentDecorator
  include MethodMissing

  attr_reader :source

  def initialize payment
    @source = payment
  end

  def credits_for_unpaid_debits
    credits.select(&:new_record?)
  end

  # Generate credits from debits
  # to be used by payment
  #
  def prepare_for_form
    @source.generate_credits self
  end

  def clear_up_form
    credits.each { |credit| credit.clear_up_form }
  end

  def credits
    @credits = [] if @credits.nil?
    generate_credits if @credits.empty?
    @credits
  end

  def generate_credit credit
    @source.credits << credit
    @credits = []
  end

  private

  def generate_credits
    @credits.push(*@source.credits.map { |d| CreditDecorator.new d })
    @credits.each { |d| d.prepare_for_form }
    @credits
  end
end