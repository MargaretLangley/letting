def sheet_factory **args
  sheet = Sheet.new sheet_attributes args
  sheet.build_address address_attributes args.fetch(:address_attributes, {})
  sheet.save!
  sheet
end

def sheet2_factory **args
  sheet = Sheet.new sheet_p2_attributes args
  sheet.save!
  sheet
end
