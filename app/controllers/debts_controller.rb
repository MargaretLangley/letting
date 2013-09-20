class DebtsController < ApplicationController

  def index
    @blocks = Block.all
  end

  def new
    properties = nil
    if params[:block].present?
      @properties = Property.search_by_house_name params[:block]
    end
  end

  def create
  end

end