
def address_new road: nil, town: nil, county: nil, prepare: false, **args
  address = base_address prepare, args
  address.road = road if road
  address.town = town if town
  address.county = county if county
  address
end

def address_create(road: nil, town: nil, county: nil, **args)
  (address = address_new(road: road, town: town, county: county, **args)).save!
  address
end

def base_address  prepare, **args
  address = Address.new min_address_attributes args
  address
end