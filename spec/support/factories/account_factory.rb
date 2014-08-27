def account_new charge: nil, **args
  account = base_account args
  account.charges << charge if charge
  account
end

def account_and_debit **args
  account = base_account args
  add_debit_attribute account, args
  account
end

private

def base_account **args
  account = Account.new account_attributes
  account.id = args[:id] if args[:id]
  account.property_id = args[:property_id] if args[:property_id]
  account
end

def add_debit_attribute account, args
  account.add_debit debit_attributes args.fetch(:debit_attributes, {})
end
