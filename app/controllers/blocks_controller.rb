class BlocksController < ApplicationController
  def index
    @blocks = Block.all
  end

  def new
    @block = Block.new
    @properties = []
  end

  def create
    if still_finding_properties?
      @block = Block.new blocks_params
      @properties = Property.search_by_house_name blocks_params[:name]
      render :new
    else
      # Block Name Matches a number of Properties
      @block = Block.new blocks_params
      if @block.save
        redirect_to blocks_path, notice: 'Block has been added!'
      else
        render :new
      end
    end
  end

  private

    def still_finding_properties?
      params_state == 'finding_properties'
    end

    def block_name_has_no_property_matches?
      @properties.empty?
    end
    helper_method :block_name_has_no_property_matches?


    def params_state
      params[:block][:state]
    end

    def blocks_params
      params.require(:block).permit :name
    end
end
