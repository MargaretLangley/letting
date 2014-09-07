def account_attributes **overrides
  {
    id: 1,
    property_id: 1,
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

def debit_generator_attributes **overrides
  {
    search_string: 'Lords',
    start_date: '1/3/2013',
    end_date: '1/4/2013',
  }.merge overrides
end
