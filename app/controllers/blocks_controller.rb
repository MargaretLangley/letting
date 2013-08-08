class BlocksController < ApplicationController
  def index
    @blocks = Block.includes(:address).all
  end

  def new
    @block = Block.new
    @properties = Property.search_by_house_name params[:search]
  end
end