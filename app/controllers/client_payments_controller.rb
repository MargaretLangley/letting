####
#
# ClientPaymentsController
#
####
#
class ClientPaymentsController < ApplicationController
  layout 'print_layout'

  def show
    @client_payment = ClientPayment.query client_id: params[:id]
  end
end
