module DB
  ####
  #
  # Payment Type
  #
  # Mapping Legacy payment types to modern types
  #
  # Used in importing charges
  #
  ####
  #
  class PaymentType
    def self.to_symbol code
      case code
      when :S      then Charge::STANDING_ORDER
      when :P, :L  then Charge::PAYMENT
      else         Charge::UNKNOWN_PAYMENT_TYPE
      end
    end
  end
end
