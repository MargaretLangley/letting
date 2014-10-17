##################################################################
#
# Seed for testing Database
#
# Creates
#
# Clients
# 1 - Mr K.S. Ranjitsinhji
# 2 - Mr B. Simpson
# 3 - Mr V. Richards
#
# Properties
#
# id: 1, human_ref: 1001, client_id: 1, Flat 28 Lords, Hendren
#                         agent_id: 1   Flat 33 Oval,  Laker
# id: 2, human_ref: 2002, client_id: 1, Flat 31 Lords, Gatting
# id: 3, human_ref: 3003, client_id: 2, Flat 31 Tavern, Hearne
# id: 4, human_ref: 4004, client_id: 3, Green Fields, Robertson
#
#
##################################################################
#
def generate_seeding
  truncate_tables
  seed_users
  seed_clients
  seed_properties
  seed_charges
  debits_and_credits
  seed_templates
  seed_invoicings
  reset_pk_sequenece_on_each_table_used
end

def truncate_tables
  Rake::Task['db:truncate_all'].invoke
end

def seed_users
  Rake::Task['db:import:users'].invoke('test')
end

def seed_clients
  Entity.create! [
    {
      entitieable_id: 1,
      entitieable_type: 'Client',
      title: 'Mr',
      initials: 'K S',
      name: 'Ranjitsinhji'
    },
    {
      entitieable_id: 2,
      entitieable_type: 'Client',
      title: 'Mr',
      initials: 'B',
      name: 'Simpson'
    },
    {
      entitieable_id: 3,
      entitieable_type: 'Client',
      title: 'Mr',
      initials: 'V',
      name: 'Richards'
    }
  ]
  Address.create! [
    {
      addressable_id: 1,
      addressable_type: 'Client',
      flat_no:  '96',
      house_name: 'Old Trafford',
      road_no:  '154',
      road:     'Talbot Road',
      district: 'Stretford',
      town:     'Manchester',
      county:   'Greater Manchester',
      postcode: 'M16 0PX'
    },
    {
      addressable_id: 2,
      addressable_type: 'Client',
      flat_no:  '64',
      house_name: 'Old Trafford',
      road_no:  '311',
      road:     'Brian Statham Way',
      district: 'Stretford',
      town:     'Manchester',
      county:   'Greater Manchester',
      postcode: 'M16 0PX'
    },
    {
      addressable_id: 3,
      addressable_type: 'Client',
      flat_no:  '84',
      house_name: 'Old Trafford',
      road_no:  '189',
      road:     'Great Stone Road',
      district: 'Stretford',
      town:     'Manchester',
      county:   'Greater Manchester',
      postcode: 'M16 0PX'
    },
    {
      addressable_id: 4,
      addressable_type: 'Template',
      flat_no:  '',
      house_name: '',
      road_no:  '77',
      road:     'Henley Road',
      district: 'Edgbaston',
      town:     'Birmingham',
      county:   'West Midlands',
      postcode: 'B32 7NR'
    }
  ]

  Client.create! [
    { id: 1, human_ref: 1 },
    { id: 2, human_ref: 2 },
    { id: 3, human_ref: 3 }
  ]
end

def seed_properties
  create_entities
  create_addresses
  create_properties
  create_agent_entities
  create_agent_addresses
  create_agents
end

def create_entities
  Entity.create! [
    {
      entitieable_id: 1,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'E P',
      name: 'Hendren'
    },
    {
      entitieable_id: 2,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'M W',
      name: 'Gatting'
    },
    {
      entitieable_id: 3,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'J W',
      name: 'Hearne'
    },
    {
      entitieable_id: 4,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'J D B',
      name: 'Robertson'
    },
  ]
end

def create_addresses
  Address.create! [
    {
      addressable_id: 1,
      addressable_type: 'Property',
      flat_no: '28',
      house_name: 'Lords',
      road_no: '2',
      road: 'St Johns Wood Road',
      town: 'London',
      county: 'Greater London',
      postcode: 'NW8 8QN'
    },
    {
      addressable_id: 2,
      addressable_type: 'Property',
      flat_no: '31',
      house_name: 'Lords',
      road_no: '2',
      road: 'St Johns Wood Road',
      town: 'London',
      county: 'Greater London',
      postcode: 'NW8 8QN'
    },
    {
      addressable_id: 3,
      addressable_type: 'Property',
      flat_no: '31',
      house_name: 'Tavern',
      road_no: '2',
      road: 'St Johns Wood Road',
      town: 'London',
      county: 'Greater London',
      postcode: 'NW8 8QN'
    },
    {
      addressable_id: 4,
      addressable_type: 'Property',
      road_no: '3',
      road: 'Green Fields',
      town: 'Suburbaton',
      county: 'Greater London',
      postcode: 'SG3 3SC'
    },
  ]
end

def create_properties
  Property.create! [
    { id: 1, human_ref: 1001, client_id: 1 },
    { id: 2, human_ref: 2002, client_id: 1 },
    { id: 3, human_ref: 3003, client_id: 2 },
    { id: 4, human_ref: 4004, client_id: 3 },
  ]
end

def create_agent_entities
  Entity.create! [
    {
      entitieable_id: 1,
      entitieable_type: 'Agent',
      title: 'Mr',
      initials: 'J C',
      name: 'Laker'
    }
  ]
end

def create_agent_addresses
  Address.create! [
    {
      addressable_id: 1,
      addressable_type: 'Agent',
      flat_no:  '33',
      house_name: 'The Oval',
      road_no:  '207b',
      road:     'Vauxhall Street',
      district: 'Kennington',
      town:     'London',
      county:   'Greater London',
      postcode: 'SE11 5SS'
    }
  ]
end

def create_agents
  Agent.create! [
    { id: 1, authorized: true,  property_id: 1 },
    { id: 2, authorized: false, property_id: 2 },
    { id: 3, authorized: false, property_id: 3 },
    { id: 4, authorized: false, property_id: 4 }
  ]
end

def seed_charges
  create_charges
  create_account
end

def create_charges
  Rake::Task['db:import:charged_ins'].invoke
  create_cycle
  create_cycle_charged_ins

  Charge.create! [
    { id: 1,             charge_type: 'Ground Rent',    cycle_id: 1,  charged_in_id: 1,
      amount: '88.08',   account_id: 1 },
    { id: 2,             charge_type: 'Service Charge', cycle_id: 1,  charged_in_id: 1,
      amount: '125.08',  account_id: 1 },
    { id: 3,             charge_type: 'Ground Rent',    cycle_id: 1,  charged_in_id: 2,
      amount: '70.00',   account_id: 2 },
    { id: 4,             charge_type: 'Service Charge', cycle_id: 1, charged_in_id: 2,
      amount: '70.00',   account_id: 3 },
  ]
end

def create_cycle
  DueOn.create! [
    { id: 1,  day: 25,  month: 3, cycle_id: 1 },
    { id: 2,  day: 29,  month: 9, cycle_id: 1 },
    { id: 3,  day: 25,  month: 6, cycle_id: 2 },
    { id: 4,  day: 29,  month: 12, cycle_id: 2 },
  ]
  Cycle.create! [
    { id: 1,  name: 'Mar/Sep', order: 1, cycle_type: 'term' },
    { id: 2,  name: 'Jun/Dec', order: 2, cycle_type: 'term' },
  ]
end

def create_cycle_charged_ins
  CycleChargedIn.create! [
    { id: 1, cycle_id: 1, charged_in_id: 1 },
    { id: 2, cycle_id: 1, charged_in_id: 2 },
    { id: 3, cycle_id: 2, charged_in_id: 1 },
  ]
end

def create_account
  Account.create! [
    { id: 1, property_id: 1 },
    { id: 2, property_id: 2 },
    { id: 3, property_id: 3 },
    { id: 4, property_id: 4 },
  ]
end

def debits_and_credits
  create_debits
  create_credits
  create_payment
end

def create_debits
  Debit.create! [
    {
      id: 1, account_id: 1,
      charge_id: 1,
      on_date: create_date(17),
      period:create_date(17)..create_date(14),
      amount: 88.08
    },
    {
      id: 2, account_id: 1,
      charge_id: 1,
      on_date: create_date(5),
      period:create_date(5)..create_date(2),
      amount: 88.08
    },
  ]
end

def create_credits
  Credit.create! [
    { id: 1,
      payment_id: 1,
      charge_id: 1,
      account_id: 1,
      on_date: create_date(15),
      amount: -88.08,
    },
  ]
end

def create_payment
  payment = Payment.new id: 1,
                        account_id: 1,
                        booked_on: create_date(15)
  payment.amount = 88.08
  payment.save!
end

def create_date months_ago
  on_date = Date.current - months_ago.months
  "#{on_date.year}/#{on_date.month }/01"
end

def seed_templates
  create_templates
  create_notices
end

def create_templates
  Template.create! [
    { id: 1,
      description: "Page 1 Invoice",
      invoice_name: "F & L Adams",
      phone: "1215030992",
      vat: "277 9904 95",
      heading1: "Lettings",
      heading2: "Invoice",
      advice1: "Hearby notice ",
      advice2: "Remittance Advice",
    },
    { id: 2,
      description:"Page 2",
      invoice_name: "F & L Adams",
      phone: "1215030992",
      vat: "277 9904 95",
      heading1: "Common Leasehold",
      heading2: "Notice to ",
      advice1: "NOTICE LEASES",
      advice2: "NOTES LANDLORDS",
    },
  ]

  Address.create! [
    {
      addressable_id: 1,
      addressable_type: 'Template',
      flat_no:  '',
      house_name: '',
      road_no:  '77',
      road:     'Henley Road',
      district: 'Edgbaston',
      town:     'Birmingham',
      county:   'West Midlands',
      postcode: 'B32 7NR'
    }
  ]

end

def create_notices
  Notice.create! [
    { id: 1,
      template_id: 2,
      instruction: "[Insert leaseholder]",
      fill_in: "To",
      sample: "Mr & Mrs Sample",
    },
    { id: 2,
      template_id: 2,
      instruction: "[address of premises]",
      fill_in: "This notice is ",
      sample: "11 Tamworth Road",
    },
    { id: 3,
      template_id: 2,
      instruction: "[Insert date]",
      fill_in: "Requires rent",
      sample: "60.00",
    },
    { id: 4,
      template_id: 2,
      instruction: "[State Period]",
      fill_in: "Payable for period",
      sample: "20March-29th Sep",
    },
    { id: 5,
      template_id: 2,
      instruction: "[Insert Landlord name]",
      fill_in: "Pay to",
      sample: "Mr Collector",
    },
    { id: 6,
      template_id: 2,
      instruction: "[Insert address]",
      fill_in: "at",
      sample: "11 High Street",
    },
    { id: 7,
      template_id: 2,
      instruction: "[Insert Landlord name]",
      fill_in: "To",
      sample: "CLIENT NAME",
    },
   ]
end

def seed_invoicings
  create_products
  create_invoices
  create_letters
  create_invoicings
end

def create_invoices
  Invoice.create! [
    { id: 1,
      invoicing_id: 1,
      billing_address: "Mr J. C. Laker\nFlat 33 The Oval\n207b Vauxhall Street\nKennington\nLondon\nSE11 5SS",
      property_ref: 1001,
      invoice_date: "2014-01-09",
      property_address: "Flat 28 Lords, 2 St Johns Wood Road, London, Greater London, NW8 8QN",
      total_arrears: 88.08,
      client_address: "Mr K.S. Ranjitsinhji\nFlat 96 Old Trafford\nDean\nSeaford\nSuss\nBN6 7QP"
    },
  ]
end

def create_products
  Product.create! [
    { id: 1,
      invoice_id: 1,
      charge_type: "Service Charge",
      date_due: "2014-09-29",
      amount: 125,
      balance: 125,
      period_first: "2014-09-29",
      period_last: "2014-09-29"
    },
    { id: 2,
      invoice_id: 1,
      charge_type: "Ground Rent",
      date_due: "2014-09-29",
      amount: 30.00,
      balance: 155.00,
      period_first: "2014-09-29",
      period_last: "2014-09-29"
    },
  ]
end

def create_invoicings
  Invoicing.create! [
    { id: 1,
      property_range: "1001 - 1001",
      period_first: "2014-09-20",
      period_last: "2014-12-04",
    },
  ]
end

def create_letters
  Letter.create! [
    { id: 1,
      invoice_id: 1,
      template_id: 1,
    },
  ]
end

def reset_pk_sequenece_on_each_table_used
  Rake::Task['db:reset_pk'].invoke
end

generate_seeding
