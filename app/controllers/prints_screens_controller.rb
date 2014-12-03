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
    @run = Run.includes(invoices: [:products]).find params[:id]
  end
end
