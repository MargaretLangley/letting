class DebtsController < ApplicationController

  def index
    @blocks = Block.all
  end

  def new
    properties = nil
    if params[:block].present?
      @properties = Property.search_by_house_name params[:block]
      # @properties.....make_debt_between? Date.new(2013,6,1)..Date.new(2013,9,30)
    end
  end

  def create
  end

  def apply
    properties = Property.properties params[:property_ids]
  end

end