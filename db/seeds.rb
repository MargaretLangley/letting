
# Seed for testing Database
# **Any new table** which has rows added should appear in pk reset at bottom.

# this starts seeding off with method call at the end of file
def generate_seeding
  truncate_tables
  seed_properties
  seed_clients
  reset_pk_sequenece_on_each_table_used
end

def truncate_tables
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE addresses RESTART IDENTITY;")
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE billing_profiles RESTART IDENTITY;")
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE clients RESTART IDENTITY;")
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE entities RESTART IDENTITY;")
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE properties RESTART IDENTITY;")
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
        entitieable_id: 1,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'X I',
        name: 'Wu'
      },
      {
        entitieable_id: 2,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'G O',
        name: 'Tigers'
      },
      {
        entitieable_id: 3,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'Y O',
        name: 'Sushi'
      }
    ]
  end

  def create_addresses
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'Property',
        road_no: '1',
        road: 'High Street',
        town: 'London',
        county: 'Greater London',
        postcode: 'SW1 1HA'
      },
      {
        addressable_id: 2,
        addressable_type: 'Property',
        road_no: '2',
        road: 'High Street',
        town: 'London',
        county: 'Greater London',
        postcode: 'SW2 2HB'
      },
      {
        addressable_id: 3,
        addressable_type: 'Property',
        road_no: '3',
        road: 'Green Fields',
        town: 'Suburbaton',
        county: 'Greater London',
        postcode: 'SG3 3SC'
      }
    ]
  end

  def create_properties
    Property.create! [
      {
        id: 1,
        human_property_id: 1001
      },
      {
        id: 2,
        human_property_id: 2002
      },
      {
        id: 3,
        human_property_id: 3003
      }
     ]
  end


  def create_billing_profile_entities
    Entity.create! [
      {
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
      {
        id: 1,
        use_profile: true,
        property_id: 1
      },
      {
        id: 2,
        use_profile: false,
        property_id: 2
      },
      {
        id: 3,
        use_profile: false,
        property_id: 3
      }
    ]
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
      }
    ]

    Client.create! [
      {
        id: 1,
        human_client_id: 1
      },
      {
        id: 2,
        human_client_id: 2
      },
      {
        id: 3,
        human_client_id: 3
      }
    ]
  end

def reset_pk_sequenece_on_each_table_used
  ActiveRecord::Base.connection.reset_pk_sequence!(Address.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(Client.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(Entity.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(Property.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(BillingProfile.table_name)
end

generate_seeding
