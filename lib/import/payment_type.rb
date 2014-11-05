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
    def self.to_symbol(code)
      case code
      when :S      then 'standing_order'
      when :P, :L  then 'payment'
      else         'unknown_payment_type'
      end
    end
  end
end
