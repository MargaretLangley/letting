module DB
  class ChargeValues
    attr_reader :charge_code
    attr_reader :max_dates_per_year

    def self.from_code(code)
      case code
      when 'GGR'  then new 'Garage Ground Rent', 4
      when 'GIns' then new 'Garage Insurance', 4
      when 'GR'   then new 'Ground Rent', 4
      when 'H'    then new 'Service Charge', 2
      when 'Ins'  then new 'Insurance', 4
      when 'M'    then new 'Service Charge', 1
      when 'Q'    then new 'Service Charge', 4
      end
    end

    def initialize charge_code, max_dates_per_year
      @charge_code = charge_code
      @max_dates_per_year = max_dates_per_year
    end

    def all_date_pairs_imported? dates_imported
      @max_dates_per_year <= dates_imported
    end

  end

end
