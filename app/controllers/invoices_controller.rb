####
#
# Invoices Controller
#
# Controller for printing invoices.
#
####
#
class InvoicesController < ApplicationController
  def show
    @invoice = Invoice.find params[:id]
  end
end
