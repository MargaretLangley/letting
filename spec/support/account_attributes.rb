def account_attributes **overrides
  {
    id: 1,
    property_id: 1,
  }.merge overrides
end

def charge_cycle_attributes **overrides
  {
    name: 'Mar/Sep',
    order: 1,
  }.merge overrides
end

def charge_attributes **overrides
  {
    charge_type: 'Ground Rent',
    charge_cycle_id: 1,
    charged_in_id: 2,
    account_id: 2,
    amount: 88.08,
    start_date: '2011-03-25',
    end_date: MAX_DATE,  # app_constants
  }.merge overrides
end

def chargeable_attributes **overrides
  {
    charge_id: 1,
    account_id: 2,
    on_date: Date.new(2013, 3, 25),
    amount: 88.08,
  }.merge overrides
end

def debit_attributes **overrides
  {
    account_id: 1,
    debit_generator_id: 1,
    charge_id: 1,
    on_date: '25/3/2013',
    amount: 88.08,
  }.merge overrides
end

def debit_generator_attributes **overrides
  {
    search_string: 'Lords',
    start_date: '1/3/2013',
    end_date: '1/4/2013',
  }.merge overrides
end
