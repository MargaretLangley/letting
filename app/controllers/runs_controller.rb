####
#
# Runs Controller
#
# Controller for printing a run of invoices to the screen.
#
# Show action displays the invoicing run onto the screen. Formatted for
# printing.
#
####
#
class RunsController < ApplicationController
  layout 'view_layout'

  def show
    @run = Run.includes(invoices: [:snapshot]).find params[:id]
  end
end
