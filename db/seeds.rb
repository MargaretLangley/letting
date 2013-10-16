
# Seed for testing Database
# **Any new table** which has rows added should appear in pk reset at bottom.

# this starts seeding off with method call at the end of file
def generate_seeding
  truncate_tables
  seed_users
  seed_clients
  seed_properties
  seed_blocks
  seed_charges
  debts_and_credits
  reset_pk_sequenece_on_each_table_used
end

  def truncate_tables
    Rake::Task['db:truncate_all'].invoke
  end

  def seed_users
    User.create! [
      {
        email: 'admin@example.com',
        password: 'password',
        password_confirmation: 'password',
        admin: true
      },
      {
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password',
        admin: false
      }
   ]
    Rake::Task['import:users'].invoke
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
      { id: 1, human_id: 1 },
      { id: 2, human_id: 2 },
      { id: 3, human_id: 3 }
    ]
  end

def seed_properties
  create_entities
  create_addresses
  create_properties
  create_billing_profile_entities
  create_billing_profile_addresses
  create_billing_profiles
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
      {
        entity_type: 'Person',
        entitieable_id: 5,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'T',
        name: 'Ambose'
      }
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
      {
        addressable_id: 5,
        addressable_type: 'Property',
        house_name: 'Wicket',
        road_no: '11',
        road: 'Wicket Street',
        town: 'Egbaston',
        county: 'Birmingham',
        postcode: 'B56 7CR'
      }
    ]
  end

  def create_properties
    Property.create! [
      { id: 1, human_id: 1001, client_id: 1 },
      { id: 2, human_id: 2002, client_id: 1 },
      { id: 3, human_id: 3003, client_id: 2 },
      { id: 4, human_id: 4004, client_id: 3 },
      { id: 5, human_id: 5005, client_id: 3 }
     ]
  end

  def create_billing_profile_entities
    Entity.create! [
      {
        entity_type: 'Person',
        entitieable_id: 1,
        entitieable_type: 'BillingProfile',
        title: 'Mr',
        initials: 'J C',
        name: 'Laker'
      }
    ]
  end

  def create_billing_profile_addresses
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'BillingProfile',
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

  def create_billing_profiles
    BillingProfile.create! [
      { id: 1, use_profile: true,  property_id: 1 },
      { id: 2, use_profile: false, property_id: 2 },
      { id: 3, use_profile: false, property_id: 3 }
    ]
  end

def seed_blocks
  Block.create! [
    { id: 1, name: 'Lords' }
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
      { id: 5, charge_type: 'Ground Rent',    due_in: 'Advance',
        amount: '10.00',  account_id: 4 },
      { id: 6, charge_type: 'Service Charge', due_in: 'Arrears',
        amount: '50.00',  account_id: 4 },
      { id: 7, charge_type: 'Ground Rent',    due_in: 'Advance',
        amount: '12.00',  account_id: 5},
      { id: 8, charge_type: 'Service Charge', due_in: 'Arrears',
        amount: '60.00',  account_id: 5 }
    ]
  end

  def create_due_ons
    DueOn.create! [
      { id: 1,  day: 1,  month: (Date.current + 1.month).month , charge_id: 1 },
      { id: 2,  day: 1,  month: 7, charge_id: 2 },
      { id: 3,  day: 1,  month: (Date.current + 1.month).month , charge_id: 3 },
      { id: 4,  day: 30, month: 9, charge_id: 4 },
      { id: 5,  day: 23, month: 3, charge_id: 5 },
      { id: 6,  day: 1,  month: 4, charge_id: 6 },
      { id: 7,  day: 23, month: 3, charge_id: 7 },
      { id: 8,  day: 27, month: 9, charge_id: 7 },
      { id: 9,  day: 23, month: 3, charge_id: 8 },
      { id: 10, day: 27, month: 9, charge_id: 8 }
    ]
  end

  def create_account
    Account.create! [
      { id: 1, property_id: 1 },
      { id: 2, property_id: 2 },
      { id: 3, property_id: 3 },
      { id: 4, property_id: 4 },
      { id: 5, property_id: 5 }
    ]
  end

def debts_and_credits
  create_debt_generator
  create_credits
end

  def create_debt_generator
    create_debts
    DebtGenerator.create! [
      {
        id: 1,
        search_string: 'Lords',
        start_date: "2013/#{(Date.current - 6.months).month }/01",
        end_date: "2013/#{(Date.current - 4.months).month }/01",
      },
      {
        id: 2,
        search_string: 'Wicket',
        start_date: "2013/#{(Date.current - 6.months).month }/01",
        end_date: "2013/#{(Date.current - 4.months).month }/01",
      }
    ]
  end

  def create_debts
    Debt.create! [
      {
        id: 1, account_id: 1,
        charge_id: 1,
        on_date: "2013/#{(Date.current - 5.months).month }/01",
        amount: 88.08,
        debt_generator_id: 1,
      },
      {
        id: 2, account_id: 1,
        charge_id: 3,
        on_date: "2013/#{(Date.current - 5.months).month }/01",
        amount: 88.08,
        debt_generator_id: 1 ,
      },
      {
        id: 3,
        account_id: 5,
        charge_id: 7,
        on_date: "2013/#{(Date.current - 5.months).month }/01",
        amount: 12,
        debt_generator_id: 2,
      },
      {
        id: 4,
        account_id: 5,
        charge_id: 8,
        on_date: "2013/#{(Date.current - 5.months).month }/01",
        amount: 60,
        debt_generator_id: 2,
      }
    ]
  end

  def create_credits
    #MISSING PAYMENT
    Credit.create! [
      { id: 1,
        payment_id: 1,
        account_id: 1,
        debt_id: 1,
        on_date: "2013/#{(Date.current - 3.months).month }/03",
        amount: 88.08,
      }
    ]
  end

def reset_pk_sequenece_on_each_table_used
  Rake::Task['db:reset_pk'].invoke
end

generate_seeding
