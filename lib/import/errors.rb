module DB
  class Error < StandardError; end
  class CreditNegativeError < Error; end
  class AccountRowTypeUnknown < Error; end
  class BalanceNotMatching < Error; end
  class ChargeUnknown < Error; end
  class ChargeCodeUnknown < Error; end
  class ChargeTypeUnknown < Error; end
  class ChargeStuctureUnknown < Error; end
  class ChargeCycleUnknown < Error; end
  class ClientRefUnknown < Error; end
  class PropertyRefUnknown < Error; end
  class ChargedInCodeUnknown < Error; end
  class NotIdempotent < Error; end
end
