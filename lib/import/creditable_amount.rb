require_relative 'errors'

module DB
  class CreditableAmount
    attr_reader :balance

    def initialize amount
      @balance = amount
    end

    def deposit amount
      @balance += amount
      self
    end

    def max_withdrawal amount
      [@balance, amount].min
    end

    # Negative amounts because - we are using the standard prepare_for_form
    # which generates a withdraw for every deposit
    # If you have two unpaid deposits and then get one withdraw
    # You are going to run out of credits - a negative total withdraw
    #
    def withdraw  amount
      @balance -= amount
      fail DB::CreditNegativeError, 'total credits is negative', caller \
        if @balance.round(2) < 0
      self
    end

    def assert_balance balance
      fail DB::BalanceNotMatching, 'Blanace not matching calculated', caller \
        if @balance != balance
    end
  end
end
