
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