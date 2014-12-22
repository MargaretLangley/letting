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
    @run = Run.includes(invoices: [:products, :debits_transaction]).find params[:id]   # rubocop: disable  Metrics/LineLength
  end
end
