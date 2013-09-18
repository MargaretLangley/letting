class PaymentsController < ApplicationController

  def index
    @payments = Payment.latest_payments(10)
  end

  def new
  end

  def create
  end

end