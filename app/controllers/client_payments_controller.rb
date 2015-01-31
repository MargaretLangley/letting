####
#
# ClientPaymentsController
#
####
#
class ClientPaymentsController < ApplicationController
  def show
    params[:years] ||= Time.zone.now.year
    @client_payment = ClientPayment.query client_id: params[:id]
  end
end
