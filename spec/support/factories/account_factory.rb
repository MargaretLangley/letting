def account_new **args
  base_account args
end

def account_create! **args
  account = base_account args
  account.save!
  account
end

def account_and_charge_new **args
  account = base_account args
  add_charge_attributes account, args
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

def add_charge_attributes account, args
  charge = account.charges.build charge_attributes \
    args.fetch(:charge_attributes, {})
  charge.due_ons.build due_on_attributes_0 args.fetch(:due_on_attribute, {})
end

def add_debit_attribute account, args
  account.add_debit debit_attributes args.fetch(:debit_attributes, {})
end
