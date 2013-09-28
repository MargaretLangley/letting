def account_attributes overrides = {}
  {
    id: 1,
    property_id: 1
  }.merge overrides
end

def charge_attributes overrides = {}
  {
    charge_type: 'Ground Rent',
    due_in: 'Advance',
    amount: '88.08'
  }.merge overrides
end

def due_on_attributes_0 overrides = {}
  {
    day: 31,
    month: 3
  }.merge overrides
end

def due_on_attributes_1 overrides = {}
  {
    day: 30,
    month: 9
  }.merge overrides
end

def due_on_monthly_attributes_0 overrides = {}
  {
    day: 1,
    month: -1
  }.merge overrides
end

def debt_attributes overrides = {}
  { account_id: 1, debt_generator_id: 1, charge_id: 1, on_date: '2013/1/30', amount: 10.05 }.merge overrides
end

def payment_attributes  overrides = {}
  { account_id: 1, debt_id: 1, on_date: '2013/1/30', amount: 10.05 }.merge overrides
end

def debt_generator_attributes overrides = {}
  { id: 1, search_string: 'Lords', start_date: '2013/3/1', end_date: '2013/4/1' }.merge overrides
end
