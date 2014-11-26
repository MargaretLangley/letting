####
#
# Invoices Controller
#
# Controller for printing invoices.
#
####
#
class InvoicesController < ApplicationController
  layout 'view_layout'

  def show
    @invoice = Invoice.find params[:id]
  end
end
