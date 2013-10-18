class PaymentsController < ApplicationController

  def new
    @payment = Payment.new
  end

  def create
    if search_payments?
      show_payment
    else
      create_payment
    end
  end

  def search_payments?
    params[:commit] == 'Search'
  end

  def show_payment
    @payment = Payment.new search_params
    @payment.account = Account.by_human_id @payment.human_id
    @payment.prepare_for_form
    render :new
  end

  def create_payment
    if payment.save
      redirect_to new_payment_path, notice: success
    else
      render :new
    end
  end

  def payment
    Payment.new payment_params
  end

  def success
    "Payment successfully created"
  end

  def search_params
    params.require(:payment).permit :human_id
  end

  def payment_params
    params.require(:payment).permit :human_id
  end

end
