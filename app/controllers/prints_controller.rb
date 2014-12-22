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
    @run = Run.includes(:invoices).find params[:id]
  end
end
