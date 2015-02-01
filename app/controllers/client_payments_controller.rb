####
#
# ClientPaymentsController
#
####
#
class ClientPaymentsController < ApplicationController
  layout 'print_layout'

  def show
    params[:years] ||= Time.zone.now.year
    @client_payment = ClientPayment.query client_id: params[:id]
  end
end
