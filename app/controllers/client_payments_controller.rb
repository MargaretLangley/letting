####
#
# ClientPaymentsController
#
# Why does this class exist?
#
# To sum payments to Clients for Ground Rent for both Mar/Sep & June/Dec
# charges.
#
####
#
class ClientPaymentsController < ApplicationController
  def show
    params[:start_date] ||= Date.new(2014, 1, 1)
    params[:end_date] ||= Time.zone.today
    @client_payment = ClientPayment.query client_id: params[:id],
                                          start_date: params[:start_date],
                                          end_date: params[:end_date]
  end
end
