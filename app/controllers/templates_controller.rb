##
#
# TemplatesController
#
# Restful actions on the Template resource
#
# Template are used to create invoices,
# they hold data needed to produce heading,
# Adam's address, notes and items on invoice and
# notice of rent due.
#
####
#
class TemplatesController < ApplicationController
  def index
    @templates = Template.order(:id)
  end

  def show
    @template = Template.find params[:id]
  end

  def edit
    @template = Template.find params[:id]
  end

  def update
    @template = Template.find params[:id]
    if @template.update templates_params
      redirect_to template_path, notice: 'Invoice Texts successfully ' \
                                       'updated!'
    else
      render :edit
    end
  end

  private

  def templates_params
    params.require(:template)
    .permit  :description,
             :invoice_name, :phone, :vat,
             :heading1, :heading2,
             :advice1, :advice2,
             address_attributes: address_params,
             notices_attributes: notices_params,
             guides_attributes: guides_params
  end

  def notices_params
    %i(id instruction fill_in sample)
  end
end
