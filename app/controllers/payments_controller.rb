class PaymentsController < ApplicationController

  def index
    @payments = Payment.latest_payments(10)
  end

  def new
    @property = Property.search(params[:search]).first \
      if params[:search].present?
    # @payment = @property.account.unpaid_debts.payments.build
    @charge =  @property.account.unpaid_debts[0].charge.charge_type
    @payment = Payment.new
    @payments = Payment.latest_payments(10)
  end

  def create
    @payment = Payment.new payments_params
    binding.pry
    if payment.save
      redirect_to new_payment_path,
                  notice: "#{@payment.account_id} successfully created"
    else
      redirect_to new_payment_path
    end
  end

  def search_param
    params[:search]
  end

  def charges_params
    [
      :id,
      :charge_type,
      :due_in,
      :amount,
      :_destroy,
      due_ons_attributes: due_on_params
    ]
  end

  def payment_params
    [:account_id, :debt_id, :on_date, :amount]
  end

end
