####
#
# Invoice
#
# The invoice letters are generated and printed
# for a range of accounts.
# Data required includes amount owing,
# due dates, date range, entities,
# address of property, agent address.
#
####
#
class InvoicesController < ApplicationController
  def index
    @properties = Property.all
  end

  def show
    @property = Property.find params[:id]
  end
end
