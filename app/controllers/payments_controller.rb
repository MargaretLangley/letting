#####
#
# PaymentsController
#
# Restful actions on the Payments resource
#
# Payments resource covers crediting the debits that the tennats are
# charged by the debt generator / invoicing system.
#
# Payments are operator generated resources. When a payment is recieved
# (by standing order or cheque) - it is entered into the system through
# this resource.
#
# Payments are associated with credits which offset the debt_generator's
# debits.
#
####
#
class PaymentsController < ApplicationController
  def index
    @payments = Payment.payments_on(params[:search])
                       .page(params[:page])
                       .load
  end

  def new
    prepare_for_new_action human_ref: params[:human_ref]
  end

  def prepare_for_new_action args = {}
    account = Account.find_by_human_ref(args[:human_ref])
    @payment = PaymentDecorator.new(Payment.new(account: account),
                                    args.slice('human_ref'))
    @payment.prepare_for_form
  end

  def create
    if search_payments?
      show_payment
    else
      create_payment
    end
  end

  def show_payment
    prepare_for_new_action search_params
    render :new
  end

  def create_payment
    @payment = PaymentDecorator
                 .new(Payment.new(payment_params.except(:human_ref)),
                      payment_params.slice('human_ref'))
    if @payment.source.save
      redirect_to new_payment_path, notice: created_message
    else
      render :new
    end
  end

  def edit
    @payment = PaymentDecorator.new Payment.find params[:id]
  end

  def update
    @payment = PaymentDecorator.new Payment.find params[:id]
    if @payment.update payment_params
      redirect_to new_payment_path, notice: updated_message
    else
      render :edit
    end
  end

  def search_payments?
    params[:commit] == 'Search'
  end

  def destroy
    @payment = Payment.find(params[:id])
    cached_message = deleted_message
    @payment.destroy
    redirect_to payments_path, alert: cached_message
  end

  private

  def created_message
    "Payment #{identy} successfully created"
  end

  def updated_message
    "#{identy} successfully updated!"
  end

  def deleted_message
    'payment successfully deleted!'
  end

  def identy
    "Ref: '#{@payment.account.property.human_ref}' " \
    "Name: '#{@payment.account.property.occupier}' " \
    "Amount: '£#{@payment.amount}'"
  end

  def search_params
    params.require(:payment).permit :human_ref
  end

  def payment_params
    params.require(:payment)
     .permit :id,
             :account_id,
             :on_date,
             :amount,
             :human_ref,
             credits_attributes: credit_attributes
  end

  def credit_attributes
    %i(id account_id charge_id debit_id on_date amount)
  end
end
