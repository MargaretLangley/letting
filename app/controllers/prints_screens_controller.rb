####
#
# Prints_Screens Controller
#
# Controller for printing a run of invoices to the screen.
#
####
#
class PrintsScreensController < ApplicationController
  layout 'view_layout'

  def show
    @run = Run.includes(invoices: [:products, :debits_transaction]).find params[:id]   # rubocop: disable  Metrics/LineLength
  end
end
