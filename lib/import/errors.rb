module DB
  class Error < StandardError; end
  class CreditNegativeError < Error; end
  class BalanceNotMatching < Error; end
  class ChargeUnknown < Error; end
end