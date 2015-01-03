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
    @client_payment = ClientPayment
                      .query client_id: params[:id], year: params[:years]
  end
end
