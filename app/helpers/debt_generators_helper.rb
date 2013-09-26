module DebtGeneratorsHelper
  def start_date
    params[:search_start_date] or DebtGenerator.default_start_date
  end

  def end_date
    params[:search_end_date] or DebtGenerator.default_end_date
  end
end