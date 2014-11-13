####
#
# Prints Controller
#
# Controller for printing invoices.
#
####
#
class PrintsController < ApplicationController
  layout 'print_layout'

  def show
    @invoicing = Invoicing.includes(runs: [invoices: [:products]])
                          .find params[:id]
  end

  private

  def invoicing_params
    params.require(:invoicing).permit :property_range,
                                      :start_date,
                                      :end_date
  end
end
