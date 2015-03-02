#####
#
# PaymentsController
#
# Restful actions on the Payments resource
#
# Payments resource covers crediting the debits that the tenants are
# charged by the debt, invoicing, system.
#
# Payments are operator generated resources. When a payment is received
# (by standing order or cheque) - it is entered into the system through
# this resource.
#
# Payments are associated with credits which offset the invoiced debits.
#
# Don't see what my options for get_ and set_
# rubocop: disable Style/AccessorMethodName
####
#
class PaymentsController < ApplicationController
  def index
    params[:date] ||= Payments.last_booked_at

    @records = Payments.on(date: params[:date]).includes(joined_tables).load

    @payments_by_dates = Payment.by_booked_at_date
  end

  def show
    @payment = PaymentDecorator.new Payment.find params[:id]
  end

  # params[:id] is the account_id returned from search_controller
  def new
    account = Account.find_by id: params[:id]
    @payment = PaymentDecorator.new(Payment.new account: account)
    @payment.prepare
    @payment.booked_at = get_booked_on
  end

  def create
    @payment = PaymentDecorator
               .new(Payment.new(payment_params.except(:human_ref)))
    set_booked_on date: @payment.booked_at
    @payment.register_booking
    if @payment.save
      redirect_to new_payment_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @payment = PaymentDecorator.new Payment.find params[:id]
  end

  def update
    @payment = PaymentDecorator.new Payment.find params[:id]
    @payment.assign_attributes payment_params
    if @payment.save
      redirect_to new_payment_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @payment = Payment.find params[:id]
    cached_message = deleted_message
    @payment.destroy
    redirect_to payments_path, flash: { delete: cached_message }
  end

  private

  def get_booked_on
    session[:payments_booked_on] ||= Time.zone.today
  end

  def set_booked_on(date:)
    session[:payments_booked_on] = date
  end

  def joined_tables
    [account: [property: [:entities]]]
  end

  def payment_params
    params.require(:payment)
      .permit %i(id account_id booked_at amount human_ref),
              credits_attributes: credit_params
  end

  def credit_params
    %i(id account_id charge_id debit_id at_time amount)
  end

  def identity
    "Payment from #{@payment.account.property.occupiers}, " \
    "Property #{@payment.account.property.human_ref}, " \
    "Amount: £#{@payment.amount}"
  end
end
