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
    @run = Run.includes(invoices: [:products]).find params[:id]
  end
end
