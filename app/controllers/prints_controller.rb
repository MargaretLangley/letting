####
#
# Prints Controller
#
# Printing the entire print run, where a print run is a collection of invoices
# selected in an invoicing to be printed.
#
# Printing route for printing the run directly without going through the view
# first.
#
####
#
class PrintsController < ApplicationController
  layout 'print_layout'

  def show
    @run = Run.includes(invoices: [:snapshot]).find params[:id]
  end
end
