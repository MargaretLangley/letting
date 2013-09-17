

def user_attributes overrides = {}
  {
    id:11,
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
     }.merge overrides
end

def ted_attributes overrides = {}
  {
    id:11,
    email: 'fred@titmus.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
     }.merge overrides
end

def fred_attributes overrides = {}
  {
    id:12,
    email: 'bob@appleyard.com',
    password: 'passwordpassword',
    password_confirmation: 'password',
    admin: true
  }.merge overrides
end

