#
# PaymentsByDates
#
# Displaying payments grouped by dates
#
class PaymentsByDatesController < ApplicationController
  def index
    params[:date] ||= Payments.last_booked_at

    @records = Payments.booked_on(date: params[:date]).includes(joined_tables)
               .load

    @payments_by_dates = Payment.by_booked_at_date
  end

  def destroy
    @payment = Payment.find params[:id]
    cached_message = deleted_message
    @payment.destroy
    redirect_to payments_by_dates_path, flash: { delete: cached_message }
  end

  private

  def joined_tables
    [account: [property: [:entities]]]
  end

  def identity
    "Payment from #{@payment.account.property.occupiers}, " \
    "Property #{@payment.account.property.human_ref}, " \
    "Amount: £#{@payment.amount}"
  end
end
