def property_factory args = {}
  property = Property.new property_attributes args
  add_contact property, args
  add_no_billing_profile property
  add_charge property
  property.save!
  property
end

def property_factory_with_billing args = {}
  property = Property.new property_attributes args
  add_contact property, args
  add_billing_profile property
  add_charge property
  property.save!
  property
end


def add_no_billing_profile bill_me
  bill_me.build_billing_profile use_profile: false
end

def add_billing_profile bill_me
  bill_me.build_billing_profile use_profile: true
  bill_me.billing_profile.build_address oval_address_attributes
  bill_me.billing_profile.entities.build oval_person_entity_attributes
end

def add_charge charge_me
  charge_me.charges.build charge_attributes
end