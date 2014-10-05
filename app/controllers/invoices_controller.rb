####
#
# Invoices Controller
#
# Controller for printing invoices.
#
####
#
class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.find all
  end

  def show
    @invoice = Invoice.find params[:id]
    @template = Template.find(1)
  end

  def invoice_params
    params.require(:invoice)
      .permit :property_range,
              :start_date,
              :end_date
  end
end
