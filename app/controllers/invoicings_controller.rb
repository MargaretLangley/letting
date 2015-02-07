####
#
# Invoicing Controller
#
# Invoicing for batches of invoices.
#
# rubocop: disable Style/AccessorMethodName
####
#
class InvoicingsController < ApplicationController
  include InvoicingHelper
  # Print button on index allows printing of complete run
  #
  def index
    @invoicings = Invoicing.page(params[:page]).default.load
  end

  # show lists out each invoice from an invoice run
  #
  def show
    @invoicing = Invoicing.find params[:id]
  end

  def new
    @invoicing = Invoicing.new \
                   property_range: SpaceOut.process(params[:search_terms]),
                   period: invoicing_start_date..invoicing_end_date
    @invoicing.generate if @invoicing.valid_arguments?
    set_invoice_date date: get_invoice_date
  end

  # create
  # invoicing_params:
  #   - property_range - property ids to be invoiced
  #   - period:        - the dates over which the invoicing occurs
  # params: invoice_date - the date on the invoice
  #
  # generate - takes the params and makes the associated run. The run comprises
  #            of a number of invoices.
  #
  def create
    set_invoice_date date: params[:invoice_date]
    @invoicing = Invoicing.new invoicing_params
    @invoicing.generate invoice_date: params[:invoice_date],
                        comments: params[:comment] \
      if @invoicing.valid_arguments?
    if @invoicing.save
      redirect_to new_invoicing_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @invoicing =
      Invoicing.includes(runs: [invoices: [snapshot: [debits: [:charge]]]])
      .find params[:id]
    @invoicing.generate if @invoicing.valid_arguments?
    set_invoice_date date: get_invoice_date
  end

  def update
    set_invoice_date date: params[:invoice_date]
    @invoicing = Invoicing.find params[:id]
    @invoicing.generate invoice_date: params[:invoice_date],
                        comments: params[:comment] \
      if @invoicing.valid_arguments?
    if @invoicing.save
      redirect_to invoicings_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @invoicing = Invoicing.find params[:id]
    cached_message = deleted_message
    @invoicing.destroy
    redirect_to invoicings_path, flash: { delete: cached_message }
  end

  private

  # Invoice_date is a date that appears on the top of an invoice
  # The value is not used for anything else.
  # invoice_date returns today's date if the session gets set to nil or ""
  #
  def get_invoice_date
    return session[:invoicings_invoice_date] \
      unless session[:invoicings_invoice_date].blank?

    session[:invoicings_invoice_date] = Time.zone.today
  end

  # All invoice_date
  #
  def set_invoice_date(date:)
    session[:invoicings_invoice_date] = params[:invoice_date] = date
  end

  def invoicing_params
    params
      .require(:invoicing)
      .permit %i(property_range period_first period_last)
  end

  def identity
    invoicing = InvoicingIndexDecorator.new @invoicing
    "Invoicing Range #{invoicing.property_range}, " \
    "Period #{invoicing.period_between}, "
  end
end
