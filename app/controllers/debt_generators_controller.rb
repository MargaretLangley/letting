class DebtGeneratorsController < ApplicationController
  def index
    @blocks = Block.all
  end

  def new
    @debt_generator = DebtGenerator.new
    if params[:block].present?
      Property.search_by_house_name(params[:block])
              .each do |property|
        @debt_generator.debts << property
                                .account
                                .generate_debts_for(Date.new(2013,6,1)..Date.new(2013,9,30))
      end
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
