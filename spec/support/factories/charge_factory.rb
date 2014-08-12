def charge_new **args
  Charge.new charge_attributes args
end

def charge_create **args
  (structure = Charge.new charge_attributes args).save!
  structure
end
