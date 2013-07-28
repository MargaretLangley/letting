# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

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

Entity.create! [
  {
    title: 'Mr',
    initials: 'X I',
    name: 'Wu'
  }
]
