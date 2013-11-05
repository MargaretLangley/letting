module DB
  ####
  #
  # ChargeCode
  #
  # One place for mappyings of charge code into other values
  #
  # Used in importing charges and account rows.
  #
  ####
  #
  class ChargeCode
    def self.to_string(code)
      case code
      when 'Bal'  then 'Arrears'
      when 'GGR'  then 'Garage Ground Rent'
      when 'GIns' then 'Garage Insurance'
      when 'GR'   then 'Ground Rent'
      when 'H'    then 'Service Charge'
      when 'Ins'  then 'Insurance'
      when 'M'    then 'Service Charge'
      when 'Q'    then 'Service Charge'
      end
    end

    def self.to_times_per_year code
      case code
      when 'GR', 'GGR', 'GIns', 'Ins', 'Q' then 4
      when 'H' then 2
      when 'M' then 1
      end
    end
  end
end
