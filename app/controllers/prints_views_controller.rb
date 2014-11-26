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
    @run = Run.includes(invoices: [:products]).find params[:id]
  end
end
