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
    @payment = Payment.new payment_params
    if @payment.save
      redirect_to payments_path, notice: success
    else
      render :new
    end
  end

  def success
    'Payment successfully created'
  end

  def search_params
    params.require(:payment).permit :human_id
  end

  def payment_params
    params.require(:payment)
     .permit :id,
             :account_id,
             :on_date,
             :amount,
             :human_id,
             credits_attributes: credit_attributes
  end

  def credit_attributes
    %i(id account_id debit_id on_date amount)
  end

end
