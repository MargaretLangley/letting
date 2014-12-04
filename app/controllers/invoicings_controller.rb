####
#
# Invoicing Controller
#
# Invoicing for batches of invoices.
#
####
#
class InvoicingsController < ApplicationController
  # Print button on index allows printing of complete run
  #
  def index
    @invoicings = Invoicing.page(params[:page]).default.load
  end

  # show lists out each invoice from an invoice run
  #
  def show
    @invoicing = Invoicing.includes(runs: [:invoices])
                          .find params[:id]
  end

  def new
    @invoicing = Invoicing.new \
                   property_range: SpaceOut.process(params[:search_terms]),
                   period: params[:start_date]..params[:end_date]
    @invoicing.generate comments: ['', ''] if @invoicing.valid_arguments?
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
    @invoicing = Invoicing.new invoicing_params
    if @invoicing.valid_arguments?
      @invoicing.generate invoice_date: params[:invoice_date],
                          comments: params[:comment]
    end
    if @invoicing.save
      redirect_to new_invoicing_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @invoicing =
      Invoicing.includes(runs: [invoices: [account: [debits: [:charge]]]])
               .find params[:id]
    @invoicing.generate comments: ['', ''] if @invoicing.valid_arguments?
  end

  def update
    @invoicing = Invoicing.find params[:id]
    if @invoicing.valid_arguments?
      @invoicing.generate invoice_date: params[:invoice_date],
                          comments: params[:comment]
    end
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

  def invoicing_params
    params.require(:invoicing).permit invoicing_attributes
  end

  def invoicing_attributes
    %i(property_range period_first period_last)
  end

  def identity
    invoicing = InvoicingIndexDecorator.new @invoicing
    "Range #{invoicing.property_range}, period: #{invoicing.period_between}"
  end

  def created_message
    "#{identity} successfully created!"
  end

  def updated_message
    "#{identity} successfully updated!"
  end

  def deleted_message
    "#{identity} successfully deleted!"
  end
end
