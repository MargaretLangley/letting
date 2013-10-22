class PaymentsController < ApplicationController

  def index
    @payments = Payment.search(search_param).page(params[:page]).load
  end

  def new
    prepare_for_new_action human_id: params[:human_id]
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
    prepare_for_new_action search_params
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

  private

  def search_param
    params[:search]
  end

  def prepare_for_new_action args = {}
    @payment = Payment.new args
    @payment.account = Account.by_human_id @payment.human_id
    @payment.prepare_for_form
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
