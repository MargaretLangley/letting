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

  private

  def invoice_params
    params.require(:invoice).permit :property_range,
                                    :start_date,
                                    :end_date
  end
end
