
def property_factory args = {}
  property = Property.new id: args[:id], human_property_id: args[:human_property_id]
  property.build_address address_attributes
  property.entities.build person_entity_attributes
  property.build_billing_profile use_profile: true
  property.billing_profile.build_address oval_address_attributes
  property.billing_profile.entities.build oval_person_entity_attributes
  property.save!
  property
end