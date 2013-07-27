
def address_attributes overrides = {}
  {
    road_no:  '10a',
    road:     'High Street',
    district: 'Kingswindford',
    town:     'Dudley',
    county:   'West Midlands',
    postcode: 'DY6 7RA'
  }.merge overrides
end