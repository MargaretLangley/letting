#
# Controller for viewing Account Arrears
#
#
class BlueInvoicingsController < ApplicationController
  def index
    @invoicings = Invoicing.blue_invoicies.page(params[:page]).default.load
  end

  def destroy
    @invoicing = Invoicing.find params[:id]
    cached_message = deleted_message
    @invoicing.destroy
    redirect_to blue_invoicings_path, flash: { delete: cached_message }
  end

  def identity
    invoicing = InvoicingIndexDecorator.new @invoicing
    "Invoicing Range #{invoicing.property_range}, " \
    "Period #{invoicing.period_between}, "
  end
end
