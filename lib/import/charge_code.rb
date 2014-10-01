module DB
  ####
  #
  # ChargeCode
  #
  # One place for mappings of charge code into other values
  #
  # Used in importing charges and account rows.
  #
  # to_string has CyclomaticComplexity of 7 with 6 acceptable.
  # rubocop:disable  Metrics/CyclomaticComplexity
  ####
  #
  class ChargeCode
    def self.to_string(code)
      case code
      when 'Bal'         then 'Arrears'
      when 'GGR'         then 'Garage Ground Rent'
      when 'GIns'        then 'Garage Insurance'
      when 'GR'          then 'Ground Rent'
      when 'H', 'M', 'Q' then 'Service Charge'
      when 'Ins'         then 'Insurance'
      end
    end

    def self.day_month_pairs code
      case code
      when 'GR', 'GGR', 'GIns', 'Ins', 'Q' then 4
      when 'H' then 2
      when 'M' then 1
      end
    end
  end
end
