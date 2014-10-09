####
#
# Prints Controller
#
# Controller for printing invoices.
#
####
#
class PrintsController < ApplicationController
  def show
    @invoicing = Invoicing.find params[:id]
  end

  private

  def invoicing_params
    params.require(:invoicing).permit :property_range,
                                      :start_date,
                                      :end_date
  end
end
