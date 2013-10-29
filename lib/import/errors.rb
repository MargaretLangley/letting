module DB
  class Error < StandardError; end
  class CreditNegativeError < Error; end
  class BalanceNotMatching < Error; end
end