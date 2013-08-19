def user_attributes overrides = {}
  {
    email: 'example@example.com',
    password: 'password',
    password_confirmation: 'password'
  }.merge overrides
end

def property_attributes overrides = {}
  {
    human_id: 2002
  }.merge overrides
end

def address_attributes overrides = {}
  {
    flat_no:  '47',
    house_name: 'Hillbank House',
    road_no:  '294',
    road:     'Edgbaston Road',
    district: 'Edgbaston',
    town:     'Birmingham',
    county:   'West Midlands',
    postcode: 'B5 7QU'
  }.merge overrides
end

def oval_address_attributes overrides = {}
  {
    flat_no:  '33',
    house_name: 'The Oval',
    road_no:  '207b',
    road:     'Vauxhall Street',
    district: 'Kennington',
    town:     'London',
    county:   'Greater London',
    postcode: 'SE11 5SS'
  }.merge overrides
end


def person_entity_attributes overrides = {}
  {
    title: 'Mr',
    initials: 'W G',
    name: 'Grace'
  }.merge overrides
end

def oval_person_entity_attributes overrides = {}
  {
    title: 'Rev',
    initials: 'V W',
    name: 'Knutt'
  }.merge overrides
end

def charge_attributes overrides = {}
  {
    charge_type: 'Ground Rent',
    due_in: 'Advance',
    amount: '88.08'
  }.merge overrides
end
