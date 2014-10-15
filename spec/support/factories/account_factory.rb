# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/ParameterLists

def account_new id: nil,
                property: nil,
                charge: nil,
                credits: nil,
                debits: nil,
                payment: nil
  account = Account.new id: id
  account.property = property if property
  account.charges << charge if charge
  account.credits << credits if credits
  account.debits = debits if debits
  account.payments << payment if payment
  account
end

def account_create id: nil,
                   property: nil,
                   charge: nil,
                   credits: nil,
                   debits: nil,
                   payment: nil
  account = account_new id: id,
                        property: property,
                        charge: charge,
                        credits: credits,
                        debits: debits,
                        payment: payment
  account.save!
  account
end
