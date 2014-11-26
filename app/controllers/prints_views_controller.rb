####
#
# Prints Controller
#
# Controller for printing invoices.
#
####
#
class PrintsViewsController < ApplicationController
  layout 'view_layout'

  def show
    @invoicing = Invoicing.includes(runs: [invoices: [:products]])
                          .find params[:id]
  end
end
