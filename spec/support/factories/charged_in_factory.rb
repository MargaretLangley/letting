def charged_in_create id: 2, name: 'Advance'
  ChargedIn.find_by(name: name) || ChargedIn.create!(id: id, name: name)
end

def charged_in_new id: 2, name: 'Advance'
  ChargedIn.find_by(name: name) || ChargedIn.new(id: id, name: name)
end

def charged_in_name(id:)
  ChargedIn.find(id).name
end
