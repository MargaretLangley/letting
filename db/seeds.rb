
# Seed for testing Database
# **Any new table** which has rows added should appear in pk reset at bottom.

# this starts seeding off with method call at the end of file
def generate_seeding
  truncate_tables
  seed_users
  seed_clients
  seed_properties
  seed_charges
  debits_and_credits
  seed_sheets
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
      entity_type: 'Person',
      entitieable_id: 1,
      entitieable_type: 'Client',
      title: 'Mr',
      initials: 'K S',
      name: 'Ranjitsinhji'
    },
    {
      entity_type: 'Person',
      entitieable_id: 2,
      entitieable_type: 'Client',
      title: 'Mr',
      initials: 'B',
      name: 'Simpson'
    },
    {
      entity_type: 'Person',
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
      entity_type: 'Person',
      entitieable_id: 1,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'E P',
      name: 'Hendren'
    },
    {
      entity_type: 'Person',
      entitieable_id: 2,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'M W',
      name: 'Gatting'
    },
    {
      entity_type: 'Person',
      entitieable_id: 3,
      entitieable_type: 'Property',
      title: 'Mr',
      initials: 'J W',
      name: 'Hearne'
    },
    {
      entity_type: 'Person',
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
      entity_type: 'Person',
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
  create_due_ons
  Charge.create! [
    { id: 1, charge_type: 'Ground Rent',    due_in: 'Advance',
      amount: '88.08',  account_id: 1 },
    { id: 2, charge_type: 'Service Charge', due_in: 'Advance',
      amount: '125.08', account_id: 1 },
    { id: 3, charge_type: 'Ground Rent',    due_in: 'Advance',
      amount: '70.00',  account_id: 2 },
    { id: 4, charge_type: 'Service Charge', due_in: 'Advance',
      amount: '70.00',  account_id: 3 },
  ]
end

def create_due_ons
  DueOn.create! [
    { id: 1,  day: 1,  month: (Date.current + 1.month).month, charge_id: 1 },
    { id: 2,  day: 1,  month: 7, charge_id: 2 },
    { id: 3,  day: 1,  month: (Date.current + 1.month).month, charge_id: 3 },
    { id: 4,  day: 30, month: 9, charge_id: 4 },
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
  create_debit_generator
  create_credits
  create_payment
end

def create_debit_generator
  create_debits
  DebitGenerator.create! [
    {
      id: 1,
      search_string: 'Lords',
      start_date: create_date(18),
      end_date: create_date(16),
    },
    {
      id: 2,
      search_string: 'Lords',
      start_date: create_date(6),
      end_date: create_date(4),
    },
  ]
end

def create_debits
  Debit.create! [
    {
      id: 1, account_id: 1,
      charge_id: 1,
      on_date: create_date(17),
      amount: 88.08,
      debit_generator_id: 1,
    },
    {
      id: 2, account_id: 1,
      charge_id: 1,
      on_date: create_date(5),
      amount: 88.08,
      debit_generator_id: 2,
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
      amount: 88.08,
    }
  ]
end

def create_payment
  Payment.create! [
    { id: 1,
      account_id: 1,
      on_date: create_date(15),
      amount: 88.08,
    }
  ]
end

def create_date months_ago
  on_date = Date.current - months_ago.months
  "#{on_date.year}/#{on_date.month }/01"
end

def seed_sheets
  create_sheets
  create_sheet_addresses
  create_notices
end

def create_sheets
  Sheet.create! [
    {
      id: 1,
      description: 'Page 1 Invoice',
      invoice_name: 'F & L Adams',
      phone: '01215030992',
      vat: '277 9904 95',
      heading1:  'Residential Lettings & Property Management',
      heading2:  'Invoice',
      advice1:  'Hearby give you notice pursuant to Section 48 of the Landlord and Tenant Act 1987 that the address in England and Wales at which notices (including notices in proceedings) may be served on your Landlord by you is:',
      advice2:  "Remittance Advice
       If paying by cheque, please detach and forward only the tear-off counterfoil of this account.CHEQUES ACT 1957: Receipts are not issued for cheque payments unless specifically requested in which case the account should be sent INTACT, endorsed RECEIPT REQUIRED together with a STAMPED ADDRESSED ENVELOPE.  PLEASE MAKE CHEQUES PAYABLE TO F&L ADAMS.
Postal Orders sent through the post shall be at the sender's risk until actually received.",
    },
    {
      id: 2,
      description: 'Page 2 Notice of Rent Due',
      invoice_name: 'F & L Adams',
      phone: '01215030992',
      vat: '277 9904 95',
      heading1:  'Commonhold and Leasehold Reform Act 2002, section 166',
      heading2:  'Notice to long leaseholders of rent due Ref No',
      advice1:  "NOTICE FOR LEASEHOLDERS
       Read this notice carefully. It sets out the amount of rent due from you and the date by which you must pay it. You are advised to seek help immediately, if you cannot pay, or dispute the amount. Those who can help you include a citizens' advice bureau, a housing advice service, a law centre and a solicitor. Show this notice and a copy of your lease to whoever helps you.

      The landlord may be able to claim additional sums from you if you do not pay by the date specified in this notice. You have the right to challenge the reasonableness of any additional sums at a leasehold valuation tribunal. Section 167 of the Commonhold and Leasehold Reform Act 2002 and regulations made under it prevent your landlord from forfeiting your lease for non-payment of rent, service charges or administration charges (or a combination of them) if the amount owed is £350 or less, or none of the unpaid amount has been outstanding for more than three years.",
      advice2:  "NOTES FOR LANDLORDS
         1. If you send this notice by post, address it to the leaseholder at the dwelling in respect of which the payment is due, unless he has notified you in writing of a different address in England or Wales at which he wishes to be given notice under section 166 of the Commonhold and Leasehold Reform Act 2002.

       2. This date must not be either less than 30 days or more than 60 days after the day on which this notice is given or before that on which the leaseholder would have been liable to make the payment in accordance with the lease.",
    }
  ]
end

def create_sheet_addresses
  Address.create! [
    {
      addressable_id: 1,
      addressable_type: 'Sheet',
      flat_no:  '',
      house_name: '',
      road_no:  '2',
      road:     'Attwood Street',
      district: '',
      town:     'Halesowen',
      county:   'West Midlands',
      postcode: 'B63 3UE'
    },
  ]
end

def create_notices
  Notice.create! [
    {
      id: 10,
      sheet_id: 2,
      instruction: '[Insert name(s)of leaseholder(s)] (note 1)',
      clause: 'To',
      proxy: 'Mr & Mrs Jones',
    },
    {
      id: 11,
      sheet_id: 2,
      instruction: '[address of premises to which the long lease relates]',
      clause: 'This notice is given in respect of',
      proxy: '11 Lichfield Road',
    },
    {
      id: 12,
      sheet_id: 2,
      instruction: '[Insert date (note 2)]',
      clause: 'It requires you to pay rent of',
      proxy: '£20 on 25th March 2016',
    },
    {
      id: 13,
      sheet_id: 2,
      instruction: '[state period]',
      clause: 'The rent is payable in respect of the period',
      proxy: '26th Sept 2015 to 25th March 2016',
    },

    {
      id: 14,
      sheet_id: 2,
      instruction: '[insert name of landlord(s) or if payment should be made to an agent name of agent]',
      clause: 'Payment should be made to ',
      proxy: 'F & L Adams',
    },

    {
      id: 15,
      sheet_id: 2,
      instruction: '[insert address]',
      clause: 'at ',
      proxy: '2 Attwood Street',
    },

    {
      id: 16,
      sheet_id: 2,
      instruction: '[insert name of landlord(s) and if not given above, address]',
      clause: 'This notice is given by',
      proxy: 'CLIENT NAME',
    },
  ]
end

def reset_pk_sequenece_on_each_table_used
  Rake::Task['db:reset_pk'].invoke
end

generate_seeding
