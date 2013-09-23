class DebtGeneratorsController < ApplicationController
  def index
    @blocks = Block.all
  end

  def new
    properties = nil
    if params[:block].present?
      @properties = Property.search_by_house_name params[:block]
      @properties.each do |property|
        debt_infos = property.charges.make_debt_between? Date.new(2013,6,1)..Date.new(2013,9,30)
        property.account.generated_debts debt_infos
        property.account.debts
      end
    end
  end

end
