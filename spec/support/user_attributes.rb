def user_attributes overrides = {}
  {
    id:10,
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password'
  }.merge overrides
end

def ted_attributes overrides = {}
  {
    id:11,
    email: 'fred@titmus.com',
    password: 'titmus',
    password_confirmation: 'titmus'
  }.merge overrides
end

def fred_attributes overrides = {}
  {
    id:12,
    email: 'bob@appleyard.com',
    password: 'appleyard',
    password_confirmation: 'appleyard'
  }.merge overrides
end

