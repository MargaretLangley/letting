
# Seed for testing Database
# **Any new table** which has rows added should appear in pk reset at bottom.

# this starts seeding off with method call at the end of file
def generate_seeding
  create_properties
  reset_pk_sequenece_on_each_table_used
end


def create_properties
  create_property
  create_address
  create_entities
  create_billing_profile
  create_billing_profile_address
  create_billing_profile_entity
end

  def create_property
    Property.create! [
      {
        id: 1,
        human_property_reference: 1001
      },
      {
        id: 2,
        human_property_reference: 2002
      },
      {
        id: 3,
        human_property_reference: 3003
      }
     ]
  end

  def create_address
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


  def create_billing_profile
    BillingProfile.create! [
      {
        id: 1,
        property_id: 1
      }
    ]
  end


  def create_billing_profile_address
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

  def create_billing_profile_entity
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

def reset_pk_sequenece_on_each_table_used
  ActiveRecord::Base.connection.reset_pk_sequence!(Property.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(Address.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(Entity.table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(BillingProfile.table_name)
end

generate_seeding
