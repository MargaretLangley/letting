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
end
