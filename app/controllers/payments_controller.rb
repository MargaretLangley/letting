class PaymentsController < ApplicationController

#   def index
#     @payments = Payment.latest_payments(10)
#   end

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
    @payment = Payment.from_human_id
    render :new
  end

  def create_payment
    if payment.save
      redirect_to new_payment_path,
                  notice: "#{@payment.account_id} successfully created"
    else
      redirect_to new_payment_path
    end
  end

  # def new_payment
  #   Payment.new ..........
  # end

#   def search_param
#     params[:search]
#   end

#   def charges_params
#     [
#       :id,
#       :charge_type,
#       :due_in,
#       :amount,
#       :_destroy,
#       due_ons_attributes: due_on_params
#     ]
#   end

#   def payment_params
#     [:account_id, :debt_id, :on_date, :amount]
#   end

end
