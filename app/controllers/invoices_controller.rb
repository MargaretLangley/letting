class InvoicesController < ApplicationController
  def new
    @property = Property.all
  end
end
