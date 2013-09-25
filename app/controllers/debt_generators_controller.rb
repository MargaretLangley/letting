class DebtGeneratorsController < ApplicationController
  def index
    @blocks = Block.all
  end

  def new
    @debt_generator = DebtGenerator.new
    properties = []
    properties = Property.search(params[:search]) if params[:search].present?
    properties.each do |property|
        @debt_generator.debts << property
                                .account
                                .generate_debts_for(Date.new(2014,6,1)..Date.new(2014,9,30))
    end
  end

  def create
    @debt_generator = DebtGenerator.new debt_generator_params
    if @debt_generator.save
      redirect_to debt_generators_path, notice: 'Debts successfully created!'
    else
      render :new
    end
  end



  private

  def debt_generator_params
    params.require(:debt_generator)
      .permit debts_attributes: debt_params
  end

  def debt_params
    [ :account_id, :charge_id, :id, :on_date, :amount ]
  end
end
