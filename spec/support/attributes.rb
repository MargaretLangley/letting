
def address_attributes overrides = {}
  {
    flat_no:  '47',
    house_name: 'Sunny Views',
    road_no:  '10a',
    road:     'High Street',
    district: 'Kingswindford',
    town:     'Dudley',
    county:   'West Midlands',
    postcode: 'DY6 7RA'
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
    initials: 'X Z',
    name: 'Ziou'
  }.merge overrides
end

def oval_person_entity_attributes overrides = {}
  {
    title: 'Rev',
    initials: 'V W',
    name: 'Knutt'
  }.merge overrides
end


