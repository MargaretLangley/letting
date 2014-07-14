class SearchDate
  def initialize date
    @date = date
  end

  def valid_date?
    @date.present? && parse_date?
  end

  def day_range
    @date.to_datetime.beginning_of_day..@date.to_datetime.end_of_day
  end

  private

  def parse_date?
    DateTime.parse @date
    rescue
      false
  end
end
