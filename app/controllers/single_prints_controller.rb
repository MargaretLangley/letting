####
#
# Single_Prints Controller
#
# SinglePrintsController for printing invoices.
#
# Show is the same as invoices/show, which puts the invoices to screen.
# This show prints the invoices out.
#
####
#
class SinglePrintsController < ApplicationController
  layout 'print_layout'

  def show
    @invoice = Invoice.find params[:id]
  end
end
