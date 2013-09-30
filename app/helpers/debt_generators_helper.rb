module DebtGeneratorsHelper
  # debt_generator isn't saved on search query only on a create
  # consequently. the params[:seach_start_date] can be changed while
  # debt_generator.start_date will remain the same (the default)
  def start_date debt_generator
    params[:search_start_date] || debt_generator.start_date
  end

  def end_date debt_generator
    params[:search_end_date] || debt_generator.end_date
  end
end