####
#
# Prints_Screens Controller
#
# Rename to RunsController
# Search PrintsScreens and prints_screens (rename in routes and permission)
#
#
# Controller for printing a run of invoices to the screen.
#
# Show action displays the invoicing run onto the screen. Formatted for
# printing.
#
####
#
class PrintsScreensController < ApplicationController
  layout 'view_layout'

  def show
    @run = Run.includes(invoices: [:snapshot]).find params[:id]
  end
end
